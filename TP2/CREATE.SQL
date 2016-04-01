----------------------------------------------
-- CREATE.SQL
----------------------------------------------
SET SERVEROUTPUT ON
ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY'
/
----------------------------------------------
-- TABLE Departement
----------------------------------------------
CREATE TABLE Departement(
    idDepartement               NUMBER
                                CONSTRAINT nn_Departement_id NOT NULL
                                CONSTRAINT pk_Departement PRIMARY KEY,
    nomDepartement              VARCHAR2(80)
                                CONSTRAINT nn_Departement_nom NOT NULL
                                CONSTRAINT ck_Departement_nom CHECK(LENGTH(nomDepartement) >= 2)
)
/

----------------------------------------------
-- TABLE Employe
----------------------------------------------
 CREATE TABLE Employe(
    idEmploye                   NUMBER
                                CONSTRAINT nn_Employe_id NOT NULL
                                CONSTRAINT pk_Employe PRIMARY KEY,
    nomEmploye                  VARCHAR2(30)
                                CONSTRAINT nn_Employe_nom NOT NULL
                                CONSTRAINT ck_Employe_nom CHECK(LENGTH(nomEmploye) >= 2),
    statutEnseignant            NUMBER(1)
                                CONSTRAINT n_Employe_statutEns NULL
                                CONSTRAINT ck_Employe_statutEns CHECK(statutEnseignant = 0 OR statutEnseignant = 1),
    statutEmpDep                NUMBER(1)
                                CONSTRAINT n_Employe_statutDep NULL
                                CONSTRAINT ck_Employe_statutDep CHECK(statutEmpDep = 0 OR statutEmpDep = 1),
    idDepartement               NUMBER
                                CONSTRAINT n_Employe_idDep NULL
                                CONSTRAINT fk_Employe_idDep REFERENCES Departement(idDepartement)
)
/

----------------------------------------------
-- TABLE Cours
----------------------------------------------
CREATE TABLE Cours(
    idCours                     NUMBER
                                CONSTRAINT nn_Cours_id NOT NULL
                                CONSTRAINT pk_Cours PRIMARY KEY,
    sigleCours                  CHAR(7)
                                CONSTRAINT nn_Cours_sigle NOT NULL
                                CONSTRAINT ck_Cours_sigle
                                    CHECK(REGEXP_LIKE(sigleCours, '([A-Z]{3}[0-9]{3}[0-9A-Z]{1})')),
    titreCours                  VARCHAR(200)
                                CONSTRAINT nn_Cours_titre NOT NULL
                                CONSTRAINT ck_Cours_titre CHECK(LENGTH(titreCours) >= 2),
    cycleCours                  NUMBER(1)
                                CONSTRAINT nn_Cours_cycle NOT NULL
                                CONSTRAINT ck_Cours_cycle CHECK(cycleCours IN (1, 2, 3)),
    idDepartement               NUMBER
                                CONSTRAINT nn_Cours_idDep NOT NULL
                                CONSTRAINT fk_Cours_idDep REFERENCES Departement(idDepartement)
)
/

----------------------------------------------
-- TABLE SessionGC
----------------------------------------------
CREATE TABLE SessionGC(
    idSession                   NUMBER
                                CONSTRAINT nn_SessionGC_id NOT NULL
                                CONSTRAINT pk_SessionGC PRIMARY KEY,
    nomSession                  VARCHAR2(20)
                                CONSTRAINT nn_SessionGC_nom NOT NULL
                                CONSTRAINT ck_SessionGC_nom CHECK(LENGTH(nomSession) >= 2),
    dateLimiteEnvoiNotes        DATE
                                CONSTRAINT nn_SessionGC_dateLimite NOT NULL
                                -- Aici probabil mai trebuie sa avem un field
                                -- cu numele luna si anul sessiunii ca sa putem compara cu un check
                                -- sa nu fie data limita mai mica de data sessiunii sau mai mare ca anul sesiunii
)
/

----------------------------------------------
-- TABLE GroupeCours
----------------------------------------------
CREATE TABLE GroupeCours(
    idGroupeCours               NUMBER
                                CONSTRAINT nn_GroupeCours_id NOT NULL
                                CONSTRAINT pk_GroupeCours PRIMARY KEY,
    noGroupeCours               CHAR(2)
                                CONSTRAINT nn_GroupeCours_no NOT NULL,
                                CONSTRAINT ck_GroupeCours_no CHECK(REGEXP_LIKE(noGroupeCours, '([0-9]{2})')),
    bordereauEstDiffuse         NUMBER(1)
                                CONSTRAINT n_GroupeCours_estDiffuse NULL
                                CONSTRAINT ck_GroupeCours_estDiffuse
                                    CHECK(bordereauEstDiffuse = 0 OR bordereauEstDiffuse = 1),
    dateConfirmationBordereau   DATE
                                CONSTRAINT n_GroupeCours_dateConfirm NULL,
    dateApprobationBordereau    DATE
                                CONSTRAINT n_GroupeCours_dateApprob NULL,
    dateTraitementBordereau     DATE
                                CONSTRAINT n_GroupeCours_dateTraitement NULL,
    idCours                     NUMBER
                                CONSTRAINT nn_GroupeCours_idCours NOT NULL
                                CONSTRAINT fk_GroupeCours_idCours REFERENCES Cours(idCours),
    idSession                   NUMBER
                                CONSTRAINT nn_GroupeCours_idSession NOT NULL
                                CONSTRAINT fk_GroupeCours_idSession REFERENCES SessionGC(idSession)
)
/

----------------------------------------------
-- TABLE StatutTransferBordereau
----------------------------------------------
CREATE TABLE StatutTransferBordereau(
    idGroupeCours               NUMBER
                                CONSTRAINT nn_StatutTransferBordereau_id NOT NULL
                                CONSTRAINT pk_StatutTransferBordereau PRIMARY KEY
                                CONSTRAINT fk_StatutTransferBordereau_id REFERENCES GroupeCours(idGroupeCours),
    valeur                      VARCHAR2(25)
                                CONSTRAINT nn_StatutTransferBordereau_val NOT NULL
                                CONSTRAINT ck_StatutTransferBordereau_val CHECK(valeur IN
                                    ('NON_TRANSFEREES', 'TRANSFEREES_NON_TRAITEES', 'TRANSFEREES_TRAITEES'))
)
/

----------------------------------------------
-- TABLE IntervalleNote
----------------------------------------------
CREATE TABLE IntervalleNote(
    idIntervalleNote            NUMBER
                                CONSTRAINT nn_IntervalleNote_id NOT NULL
                                CONSTRAINT pk_IntervalleNote PRIMARY KEY,
    lettre                      VARCHAR(2)
                                CONSTRAINT nn_IntervalleNote_lettre NOT NULL
                                CONSTRAINT ck_IntervalleNote_lettre CHECK(lettre IN
                                    ('A+', 'A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C-', 'D+', 'D', 'E', 'EZ')),
    noteMin                     NUMBER(2,2)
                                CONSTRAINT nn_IntervalleNote_noteMin NOT NULL
                                CONSTRAINT ck_IntervalleNote_noteMin CHECK(noteMin > 0 AND noteMin < 100),
    idGroupeCours               NUMBER
                                CONSTRAINT nn_IntervalleNote_idGC NOT NULL
                                CONSTRAINT fk_IntervalleNote_idGC REFERENCES GroupeCours(idGroupeCours)
)
/

----------------------------------------------
-- TABLE ProgrammeEtudes
----------------------------------------------
CREATE TABLE ProgrammeEtudes(
    idProgrammeEtudes           NUMBER
                                CONSTRAINT nn_ProgrammeEtudes_id NOT NULL
                                CONSTRAINT pk_ProgrammeEtudes PRIMARY KEY,
    titreProgramme              VARCHAR2(130)
                                CONSTRAINT nn_ProgrammeEtudes_titre NOT NULL
                                CONSTRAINT ck_ProgrammeEtudes_titre CHECK(LENGTH(titreProgramme) >= 2),
    codeProgramme               CHAR(4)
                                CONSTRAINT nn_ProgrammeEtudes_code NOT NULL
                                CONSTRAINT ck_ProgrammeEtudes_code CHECK(REGEXP_LIKE(codeProgramme, '([0-9]{4})')),
    cycleProgramme              NUMBER(1)
                                CONSTRAINT nn_ProgrammeEtudes_cycle NOT NULL
                                CONSTRAINT ck_ProgrammeEtudes_cycle CHECK(cycleProgramme IN (1, 2, 3))
)
/

----------------------------------------------
-- TABLE Etudiant
----------------------------------------------
CREATE TABLE Etudiant(
    idEtudiant                  NUMBER
                                CONSTRAINT nn_Etudiant_id NOT NULL
                                CONSTRAINT pk_Etudiant PRIMARY KEY,
    nomEtudiant                 VARCHAR2(30)
                                CONSTRAINT nn_Etudiant_nom NOT NULL
                                CONSTRAINT ck_Etudiant_nom CHECK(LENGTH(nomEtudiant) >= 2),
    codePermanentEtudiant       CHAR(12)
                                CONSTRAINT nn_Etudiant_code NOT NULL
                                CONSTRAINT ck_Etudiant_code
                                    CHECK(REGEXP_LIKE(codePermanentEtudiant, '([A-Z]{4}[0-9]{8})'))
)
/

----------------------------------------------
-- TABLE InscriptionProgramme
----------------------------------------------
CREATE TABLE InscriptionProgramme(
    idInscriptionProgramme      NUMBER
                                CONSTRAINT nn_IP_id NOT NULL
                                CONSTRAINT pk_IP PRIMARY KEY,
    idEtudiant                  NUMBER
                                CONSTRAINT nn_IP_idEtud NOT NULL
                                CONSTRAINT fk_IP_idEtud REFERENCES Etudiant(idEtudiant),
    idProgrammeEtudes           NUMBER
                                CONSTRAINT nn_IP_idProgEtud NOT NULL
                                CONSTRAINT fk_IP_idProgEtud REFERENCES ProgrammeEtudes(idProgrammeEtudes)
)
/

----------------------------------------------
-- TABLE StatutInscription
----------------------------------------------
CREATE TABLE StatutInscription(
    idStatutInscription         NUMBER
                                CONSTRAINT nn_StatutInscription_id NOT NULL
                                CONSTRAINT pk_StatutInscription PRIMARY KEY,
    valeurStatut                VARCHAR(2)
                                CONSTRAINT nn_StatutInscription_val NOT NULL
                                CONSTRAINT ck_StatutInscription_val CHECK(valeurStatut IN
                                            ('##', 'XE', 'XX', 'FX', 'RX', 'UX', 'W')),
    description                 VARCHAR(100)
                                CONSTRAINT nn_StatutInscription_desc NOT NULL
                                CONSTRAINT ck_StatutInscription_desc CHECK(LENGTH(description) >= 2)
)
/

----------------------------------------------
-- TABLE InscriptionGroupeCours
----------------------------------------------
CREATE TABLE InscriptionGroupeCours(
    idInscriptionGroupeCours    NUMBER
                                CONSTRAINT nn_IGC_id NOT NULL
                                CONSTRAINT pk_IGC PRIMARY KEY,
    idEtudiant                  NUMBER
                                CONSTRAINT nn_IGC_idEtud NOT NULL
                                CONSTRAINT fk_IGC_idEtud REFERENCES Etudiant(idEtudiant),
    idGroupeCours               NUMBER
                                CONSTRAINT nn_IGC_idGC NOT NULL
                                CONSTRAINT fk_IGC_idGC REFERENCES GroupeCours(idGroupeCours),
    idProgrammeEtudes           NUMBER
                                CONSTRAINT nn_IGC_idProgEtud NOT NULL
                                CONSTRAINT fk_IGC_idProgEtud REFERENCES ProgrammeEtudes(idProgrammeEtudes),
    idStatutInscription         NUMBER
                                CONSTRAINT n_IGC_idStatut NULL
                                CONSTRAINT fk_IGC_idStatut REFERENCES StatutInscription(idStatutInscription)
)
/

----------------------------------------------
-- TABLE NoteLettree
----------------------------------------------
CREATE TABLE NoteLettree(
    idInscriptionGroupeCours    NUMBER
                                CONSTRAINT nn_NL_id NOT NULL
                                CONSTRAINT pk_NL PRIMARY KEY
                                CONSTRAINT fk_NL_id REFERENCES InscriptionGroupeCours(idInscriptionGroupeCours),
    valeurNote                  NUMBER(2,2)
                                CONSTRAINT n_NL_valeur NULL
                                CONSTRAINT ck_NL_valeur CHECK(valeurNote >= 0 AND valeurNote <= 100)
)
/

----------------------------------------------
-- TABLE Evaluation
----------------------------------------------
CREATE TABLE Evaluation(
    idEvaluation                NUMBER
                                CONSTRAINT nn_Eval_id NOT NULL
                                CONSTRAINT pk_Eval PRIMARY KEY,
    nomEvaluation               VARCHAR2(20)
                                CONSTRAINT nn_Eval_nom NOT NULL
                                CONSTRAINT ck_Eval_nom CHECK(LENGTH(nomEvaluation) >= 2),
    resultatMaximalEvaluation   NUMBER
                                CONSTRAINT nn_Eval_resMax NOT NULL
                                CONSTRAINT ck_Eval_resMax
                                    CHECK(resultatMaximalEvaluation > 0 AND resultatMaximalEvaluation <= 100),
    ponderationEvaluation       NUMBER
                                CONSTRAINT nn_Eval_pond NOT NULL
                                CONSTRAINT ck_Eval_pond
                                    CHECK(ponderationEvaluation > 0 AND ponderationEvaluation <= 100),
    evaluationEstDiffuse        NUMBER(1)
                                CONSTRAINT nn_Eval_diffuse NOT NULL
                                CONSTRAINT ck_Eval_diffuse CHECK(evaluationEstDiffuse = 0 OR evaluationEstDiffuse = 1),
	moyenneEvaluation           NUMBER(2,2)
	                            CONSTRAINT n_Res_moyenne NULL,
	ecartTypeEvaluation         NUMBER(2,2)
	                            CONSTRAINT n_Res_moyenne NULL,
    idGroupeCours               NUMBER
                                CONSTRAINT nn_Eval_idGC NOT NULL
                                CONSTRAINT fk_Eval_idGC REFERENCES GroupeCours(idGroupeCours)
)
/

----------------------------------------------
-- TABLE Resultat
----------------------------------------------
CREATE TABLE Resultat(
    idResultat                  NUMBER
                                CONSTRAINT nn_Res_id NOT NULL
                                CONSTRAINT pk_Res PRIMARY KEY,
    idInscriptionGroupeCours    NUMBER
                                CONSTRAINT nn_Res_idIGC NOT NULL
                                CONSTRAINT fk_Res_idIGC REFERENCES InscriptionGroupeCours(idInscriptionGroupeCours),
    idEvaluation                NUMBER
                                CONSTRAINT nn_Res_idEvaluation NOT NULL
                                CONSTRAINT fk_Res_idEvaluation REFERENCES Evaluation(idEvaluation),
    resultatEtudiant            NUMBER(2,2)
                                CONSTRAINT nn_Res_resultat NOT NULL
                                CONSTRAINT ck_Res_resultat CHECK(resultatEtudiant >= 0 AND resultatEtudiant <= 100)
)
/