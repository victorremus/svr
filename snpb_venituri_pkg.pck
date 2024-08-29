create or replace package snpb_venituri_pkg is
    --
    FUNCTION get_valuta_id_principal (p_client_id CLN_CLIENTI.client_id%TYPE) RETURN NUMBER; -- returnez valuta contului prinicpal per client
    --
    FUNCTION get_venit_lunar (p_client_id CLN_CLIENTI.client_id%TYPE) RETURN NUMBER; -- returnez venitul lunar al unui client in valuta contului principal
    -- 
    FUNCTION get_rulaj_comercial_pf(p_client_id CLN_CLIENTI.client_id%TYPE, p_de_la DATE, p_pana_la DATE) RETURN NUMBER; -- retruneaza rulajul comercial per client in perioada data
    --
end snpb_venituri_pkg;
/
CREATE OR REPLACE PACKAGE BODY snpb_venituri_pkg
IS
    --
    g_valuta_id_ron     CLN_SURSE_FONDURI.valuta_id%TYPE := id_valuta ('RON');
    g_pachet   CONSTANT VARCHAR2 (30) := 'SNPB_VENITURI_PKG';
    --
    FUNCTION get_valuta_id_principal (p_client_id CLN_CLIENTI.client_id%TYPE)
        RETURN NUMBER
    IS
        /*
        Venit principal in ordinea prioritatii pentru PF
         SAL     0
         PENS    1
         INDEP   2
         MATRN   3
         DA      4
         ALTE    5
        Ordine moneda in caz de egalitate intre venituri
                        RON     0
                        EUR     1
                        USD     2
        Presupun ca poate fi un singur salariu sau o singura pensie per client, intr-o singura moneda
        */
        CURSOR c_tip_client (cp_client_id CLN_CLIENTI.client_id%TYPE)
        IS
            SELECT client_tip
              FROM cln_clienti
             WHERE client_id = cp_client_id;
        --
        CURSOR c_venituri (
            cp_client_id   CLN_CLIENTI.client_id%TYPE,
            cp_tip_venit   CLN_SURSE_FONDURI_V.sursa_fd_tip_sv%TYPE)
        IS
              SELECT valoare, valuta_id
                FROM cln_surse_fonduri_v
               WHERE     client_id = cp_client_id
                     AND sursa_fd_tip_sv = cp_tip_venit
                     AND valoare IS NOT NULL
            ORDER BY round_suma (curs_suma (valoare,
                                            'CBNR',
                                            valuta_id,
                                            g_valuta_id_ron,
                                            data_sys),
                                 g_valuta_id_ron) DESC;
        --
        CURSOR c_venituri_2 (cp_client_id CLN_CLIENTI.client_id%TYPE)
        IS
            WITH -- compar veniturile convertite in RON si il iau pe cel mai mare; daca mai multe sunt egale, prioritizez in functie de moneda
                x_currency
                AS
                    (SELECT 0 AS prio, 'RON' AS currency FROM DUAL
                     UNION ALL
                     SELECT 1 AS prio, 'EUR' AS currency FROM DUAL
                     UNION ALL
                     SELECT 2 AS prio, 'USD' AS currency FROM DUAL)
              SELECT round_suma (curs_suma (s1.valoare,
                                            'CBNR',
                                            valuta_id,
                                            g_valuta_id_ron,
                                            data_sys),
                                 g_valuta_id_ron)    AS val_ron,
                     sursa_fd_tip_sv,
                     valoare,
                     valuta_id
                FROM cln_surse_fonduri_v s1, x_currency x
               WHERE     client_id = cp_client_id
                     AND s1.sursa_fd_tip_sv IN ('INDEP',
                                                'MATRN',
                                                'DA',
                                                'ALTE')
                     AND NOT EXISTS
                             (SELECT 1
                                FROM cln_surse_fonduri_v s2
                               WHERE     s1.client_id = s2.client_id
                                     AND s2.sursa_fd_tip_sv IN ('SAL', 'PENS'))
                     AND s1.valoare IS NOT NULL
                     AND x.currency = s1.valuta_cod
            ORDER BY round_suma (curs_suma (s1.valoare,
                                            'CBNR',
                                            valuta_id,
                                            g_valuta_id_ron,
                                            data_sys),
                                 g_valuta_id_ron) DESC, x.prio;
        --
        v_tip_client            CLN_CLIENTI.client_tip%TYPE;
        v_valuta_id_principal   CLN_SURSE_FONDURI.valuta_id%TYPE;
        l_venituri              c_venituri%ROWTYPE;
        l_venituri_2            c_venituri_2%ROWTYPE;
    --
    BEGIN
        IF p_client_id IS NULL
        THEN
            raise_application_error (-20001, g_pachet || '/ Client ID nu poate fi NULL !');
        END IF;
        --
        OPEN c_tip_client (p_client_id);
        FETCH c_tip_client INTO v_tip_client;
        CLOSE c_tip_client;
        --
        IF v_tip_client = 'F'
        THEN
            OPEN c_venituri (p_client_id, 'SAL');
            FETCH c_venituri INTO l_venituri;
            IF c_venituri%FOUND
            THEN
                v_valuta_id_principal := l_venituri.valuta_id;
                CLOSE c_venituri;
            ELSE
                IF c_venituri%ISOPEN
                THEN
                    CLOSE c_venituri;
                END IF;
                --
                OPEN c_venituri (p_client_id, 'PENS');
                FETCH c_venituri INTO l_venituri;
                IF c_venituri%FOUND
                THEN
                    v_valuta_id_principal := l_venituri.valuta_id;
                    CLOSE c_venituri;
                ELSE -- nu am salariu si nici pensie, caut venit printre celelalte tipuri si iau valuta de la cpontul cu cea mai mare valoare in RON; in caz de egalitate, asez in ordinea monedei
                    IF c_venituri%ISOPEN
                    THEN
                        CLOSE c_venituri;
                    END IF;
                    --
                    OPEN c_venituri_2 (p_client_id);
                    FETCH c_venituri_2 INTO l_venituri_2;
                    v_valuta_id_principal := l_venituri_2.valuta_id;
                    CLOSE c_venituri_2;
                --
                END IF;
            END IF;
        ELSIF v_tip_client = 'J'
        THEN                       -- a se completa pe viitor daca va fi cazul
            raise_application_error (-20001, g_pachet || '/Tip client PJ !');
        ELSE
            raise_application_error (-20001, g_pachet || '/Tip client invalid !');
        END IF;
        --
        RETURN v_valuta_id_principal;
    --
    EXCEPTION
        WHEN OTHERS
        THEN
            IF c_venituri%ISOPEN
            THEN
                CLOSE c_venituri;
            END IF;
            --
            IF c_venituri_2%ISOPEN
            THEN
                CLOSE c_venituri_2;
            END IF;
            --
            raise_application_error (-20001, g_pachet || '/' || SQLERRM);
    END get_valuta_id_principal;
    --
    FUNCTION get_venit_lunar (p_client_id CLN_CLIENTI.client_id%TYPE)
        RETURN NUMBER
    IS
        CURSOR c_venit (cp_client_id   CLN_CLIENTI.client_id%TYPE,
                        cp_valuta_id   CLN_SURSE_FONDURI.valuta_id%TYPE)
        IS
            SELECT SUM (round_suma (curs_suma (valoare,
                                               'CBNR',
                                               valuta_id,
                                               cp_valuta_id,
                                               data_sys),
                                    cp_valuta_id))    AS suma
              FROM cln_surse_fonduri_v
             WHERE client_id = cp_client_id AND valoare IS NOT NULL;
        --
        v_return   c_venit%ROWTYPE;
    --
    BEGIN
        OPEN c_venit (p_client_id, get_valuta_id_principal (p_client_id));
        FETCH c_venit INTO v_return;
        CLOSE c_venit;
        --
        RETURN NVL (v_return.suma, 0);
    --
    EXCEPTION
        WHEN OTHERS
        THEN
            RETURN 0;
    END get_venit_lunar;
    --
    FUNCTION get_rulaj_comercial_pf (p_client_id    CLN_CLIENTI.client_id%TYPE,
                                 p_de_la            DATE,
                                 p_pana_la          DATE)
        RETURN NUMBER
    IS
        v_rulaj NUMBER;
    BEGIN
        IF p_client_id IS NULL OR p_de_la IS NULL OR p_pana_la IS NULL
        THEN
            raise_application_error (-20001, g_pachet || '/' || 'Parametri incorecti');
        END IF;
        --
        SELECT
            SUM (round_suma (curs_suma (nc.suma,
                                       'CBNR',
                                       c_crsp.valuta_id,
                                       get_valuta_id_principal (p_client_id),
                                       data_sys),
                            get_valuta_id_principal (p_client_id)))
            INTO v_rulaj
        FROM    cnt_plan_conturi        pc_crsp,
                cnt_conturi             c_crsp,
                opr_tranzactii_nc_sume  nc
        WHERE     c_crsp.cont_sintetic_id = pc_crsp.cont_sintetic_id
            AND c_crsp.cont_id = nc.cont_id_corespondent
            AND pc_crsp.cont_sintetic_cod NOT LIKE '3721%'     --elimin pozitie
            AND pc_crsp.cont_sintetic_cod NOT LIKE '3722%' --elimin contravaloare
            AND pc_crsp.cont_sintetic_cod NOT LIKE '2533%'     --nu e colateral
            AND pc_crsp.cont_sintetic_cod NOT LIKE '2534%'     --nu e colateral
            AND pc_crsp.cont_sintetic_cod NOT IN ('25310.000',
                                                 '25320.000',
                                                 '25410.000',
                                                 '25420.000')
            AND nc.data_operarii BETWEEN p_de_la AND p_pana_la
            AND nc.cont_id IN (SELECT cont_id
                                    FROM cnt_conturi
                                WHERE client_id = p_client_id)
            AND (SELECT client_id
                    FROM cnt_conturi cc2
                    WHERE cc2.cont_id = nc.cont_id_corespondent) != p_client_id;
            --
            RETURN v_rulaj;
            --
    EXCEPTION 
        WHEN OTHERS THEN
            raise_application_error (-20001, g_pachet || '/' || SQLERRM);
    END get_rulaj_comercial_pf;
--
END snpb_venituri_pkg;
/
