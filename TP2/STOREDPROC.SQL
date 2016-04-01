----------------------------------------------
-- PROCEDURE CalculeMoyenne
----------------------------------------------
DECLARE
    ex_id_inexistant EXCEPTION;

CREATE OR REPLACE PROCEDURE CalculeMoyenne(p_idGroupeCours GroupeCours.idGroupeCours%type) is
    v_moyenne Evaluation.moyenneEvaluation%type;
BEGIN
    SELECT AVG(Res.resultatEtudiant) INTO v_moyenne
        FROM Resultat Res NATURAL JOIN Evaluation Ev
            WHERE Ev.idGroupeCours = p_idGroupeCours;

    IF v_moyenne IS NULL THEN
        RISE ex_id_inexistant;
        --DBMS_OUTPUT.PUT_LINE('GroupeCours inexistant.');        
    ELSE
        UPDATE Evaluation
            SET moyenneEvaluation = v_moyenne
            WHERE idGroupeCours = p_idGroupeCours;
        COMMIT;
    END IF;

EXCEPTION
    WHEN ex_id_inexistant THEN
        DBMS_OUTPUT.PUT_LINE('GroupeCours inexistant.');
        --RAISE_APPLICATION_ERROR(-20100, 'GroupeCours inexistant.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, 'Erreur interne. - ' ||SQLCODE||' -ERROR'||SQLERRM);
END CalculeMoyenne;
/    