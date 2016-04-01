----------------------------------------------
-- PROCEDURE CalculeMoyenne
----------------------------------------------
CREATE OR REPLACE PROCEDURE CalculeMoyenne(p_idGroupeCours GroupeCours.idGroupeCours%type) is
    v_moyenne Evaluation.moyenneEvaluation%type;
BEGIN
    SELECT AVG(Res.resultatEtudiant) INTO v_moyenne
        FROM Resultat Res NATURAL JOIN Evaluation Ev
            WHERE Ev.idGroupeCours = p_idGroupeCours;

    UPDATE Evaluation
        SET moyenneEvaluation = v_moyenne
        WHERE idGroupeCours = p_idGroupeCours;
    COMMIT;

EXCEPTION
    WHEN no_data_found THEN
        RAISE_APPLICATION_ERROR(-20100, 'GroupeCours inexistant.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, 'Erreur interne.' - '
                                        ||SQLCODE||' -ERROR'||SQLERRM);
END CalculeMoyenne;
/    