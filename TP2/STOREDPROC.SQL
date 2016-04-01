----------------------------------------------
-- PROCEDURE CalculeMoyenne
----------------------------------------------
CREATE OR REPLACE PROCEDURE CalculeMoyenne(p_idGroupeCours GroupeCours.idGroupeCours%type) is
    v_moyenne Evaluation.moyenneEvaluation%type := 0;
BEGIN
    SELECT AVG(Res.resultatEtudiant) INTO v_moyenne
        FROM Resultat Res NATURAL JOIN Evaluation Ev
            WHERE Ev.idGroupeCours = p_idGroupeCours;
    dbms_output.put_line('v_moyenne= '|| v_moyenne);
    UPDATE Evaluation
        SET moyenneEvaluation = v_moyenne
        WHERE idGroupeCours = p_idGroupeCours;
    COMMIT;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20100, 'GroupeCours inexistant.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, 'Erreur interne. - ' ||SQLCODE||' -ERROR'||SQLERRM);
END CalculeMoyenne;
/    