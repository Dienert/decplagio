-----------------------------------------------------
-- Export file for user SCA                        --
-- Created by Emerson Diego on 21/5/2009, 10:17:47 --
-----------------------------------------------------

--Creating table CAMPI
--====================
create table CAMPI
(
  CAM_CAMPUS        NUMERIC(1) not null,
  CAM_DESCRICAO     CHARACTER VARYING(40) not null,
  CAM_REPRESENTACAO CHARACTER VARYING(10)
);

alter table CAMPI
  add constraint CAM_PK primary key (CAM_CAMPUS);

--Creating table SETORES
--======================
create table SETORES
(
  SET_COD_SETOR CHARACTER VARYING(8) not null,
  SET_DESCRICAO CHARACTER VARYING(60),
  SET_CAMPUS    NUMERIC(1) not null,
  SET_TELEFONE  CHARACTER VARYING(15),
  SET_FAX       CHARACTER VARYING(15),
  SET_EMAIL     CHARACTER VARYING(40),
  SET_HOME_PAGE CHARACTER VARYING(60)
);
alter table SETORES
  add constraint SET_PK primary key (SET_COD_SETOR);
alter table SETORES
  add constraint SET_CAM_FK foreign key (SET_CAMPUS)
  references CAMPI (CAM_CAMPUS);

--Creating table CURSOS
--=====================
create table CURSOS
(
  CUR_COD_CURSO          NUMERIC(8) not null,
  CUR_DESCRICAO          CHARACTER VARYING(40),
  CUR_STATUS             CHAR(1) not null,
  CUR_GRAU_CURSO         CHARACTER VARYING(2) not null,
  CUR_ATO_CRIACAO        CHARACTER VARYING(40),
  CUR_REGIME_ORIGINAL    NUMERIC(1),
  CUR_SET_COD_SETOR      CHARACTER VARYING(8) not null,
  CUR_CAMPUS             NUMERIC(1) not null,
  CUR_TURNO              NUMERIC(1) not null,
  CUR_ANO_PERIODO_INICIO CHARACTER VARYING(6),
  CUR_COD_INEP           NUMERIC(8),
  CUR_COD_HAB_INEP       NUMERIC(8),
  CUR_MODALIDADE         CHAR(2)
);
comment on column CURSOS.CUR_TURNO
  is '1 - INTEGRAL; 2 - NOITE; 3 - TARDE; 4 - MANHA';
comment on column CURSOS.CUR_MODALIDADE
  is 'GLC - LIC. CURTA; GLP - LIC. PLENA; GBA - BACH; GLB - LIC. PLENA E BACH; GTE - TECN.; GEP - ESPEC. PROFISSAO;';
alter table CURSOS
  add constraint CUR_PK primary key (CUR_COD_CURSO);
alter table CURSOS
  add constraint CUR_CAM_FK foreign key (CUR_CAMPUS)
  references CAMPI (CAM_CAMPUS);
alter table CURSOS
  add constraint CUR_SET_FK foreign key (CUR_SET_COD_SETOR)
  references SETORES (SET_COD_SETOR);
alter table CURSOS
  add constraint CUR_GRAU_CURSO_CK
  check (CUR_GRAU_CURSO IN ('M','G','PE','PM','PD'));
alter table CURSOS
  add constraint CUR_SITUACAO_CK
  check (CUR_STATUS IN ('A', 'I'));
alter table CURSOS
  add constraint CUR_TURNO_CK
  check (CUR_TURNO IN (1, 2, 3, 4));
create index CUR_STATUS_PK on CURSOS (CUR_STATUS);

--Creating table CURRICULOS_CURSOS
--================================
create table CURRICULOS_CURSOS
(
  CCU_CUR_COD_CURSO       NUMERIC(8) not null,
  CCU_COD_CURRICULO       NUMERIC(5) not null,
  CCU_REGIME              NUMERIC(1) not null,
  CCU_DURACAO_MIN         NUMERIC(2) not null,
  CCU_DURACAO_MAX         NUMERIC(2),
  CCU_DURACAO_MED         NUMERIC(2),
  CCU_CH_CR_MIN           NUMERIC(4) not null,
  CCU_CH_CR_MAX           NUMERIC(4),
  CCU_CH_MIN_DISC_OBRI    NUMERIC(4) not null,
  CCU_CH_MIN_DISC_OPT     NUMERIC(4) not null,
  CCU_CH_MIN_ATIV_COMP    NUMERIC(4) not null,
  CCU_CH_MIN_TOTAL        NUMERIC(4) not null,
  CCU_CR_MIN_DISC_OBRI    NUMERIC(4) not null,
  CCU_CR_MIN_DISC_OPT     NUMERIC(4) not null,
  CCU_CR_MIN_ATIV_COMP    NUMERIC(4) not null,
  CCU_CR_MIN_TOTAL        NUMERIC(4) not null,
  CCU_QT_MIN_DISC_OBRI    NUMERIC(4) not null,
  CCU_QT_MIN_DISC_OPT     NUMERIC(4) not null,
  CCU_QT_MIN_ATIV_COMP    NUMERIC(4) not null,
  CCU_QT_MIN_TOTAL        NUMERIC(4) not null,
  CCU_NUM_ITRUP_PAR_MAX   NUMERIC(2),
  CCU_NUM_ITRUP_TOT_MAX   NUMERIC(2),
  CCU_RESOLUCAO           CHARACTER VARYING(15),
  CCU_NUM_MATR_INST_MAX   NUMERIC(2),
  CCU_NUM_MATR_EXTC_MAX   NUMERIC(3),
  CCU_VALIDA_CR_CH_MINIMO CHARACTER VARYING(1)
);
comment on column CURRICULOS_CURSOS.CCU_REGIME
  is '1 - semestral ; 2 - anual';
alter table CURRICULOS_CURSOS
  add constraint CCU_PK primary key (CCU_CUR_COD_CURSO, CCU_COD_CURRICULO);
alter table CURRICULOS_CURSOS
  add constraint CCU_CUR_FK foreign key (CCU_CUR_COD_CURSO)
  references CURSOS (CUR_COD_CURSO);
alter table CURRICULOS_CURSOS
  add constraint CCU_REGIME_CK
  check (CCU_Regime BETWEEN 1 AND 2);
alter table CURRICULOS_CURSOS
  add constraint SIM_NÃO25
  check (CCU_VALIDA_CR_CH_MINIMO IN ('S', 'N'));

--Creating table AREAS_ESPEC_CURRICULOS
--=====================================
create table AREAS_ESPEC_CURRICULOS
(
  AEC_CCU_CUR_COD_CURSO NUMERIC(8) not null,
  AEC_CCU_COD_CURRICULO NUMERIC(5) not null,
  AEC_COD_AREA          NUMERIC(2) not null,
  AEC_DESCRICAO         CHARACTER VARYING(20)
);
comment on column AREAS_ESPEC_CURRICULOS.AEC_CCU_CUR_COD_CURSO
  is 'Código do Curso';
comment on column AREAS_ESPEC_CURRICULOS.AEC_CCU_COD_CURRICULO
  is 'Código do Currículo';
comment on column AREAS_ESPEC_CURRICULOS.AEC_COD_AREA
  is 'Código do Pólo EAD';
comment on column AREAS_ESPEC_CURRICULOS.AEC_DESCRICAO
  is 'Município-UF do Pólo EAD';
alter table AREAS_ESPEC_CURRICULOS
  add constraint AEC_PK primary key (AEC_CCU_CUR_COD_CURSO, AEC_CCU_COD_CURRICULO, AEC_COD_AREA);
alter table AREAS_ESPEC_CURRICULOS
  add constraint AEC_CCU_FK foreign key (AEC_CCU_CUR_COD_CURSO, AEC_CCU_COD_CURRICULO)
  references CURRICULOS_CURSOS (CCU_CUR_COD_CURSO, CCU_COD_CURRICULO);

--Creating table FORMAS_INGRESSO
--==============================
create table FORMAS_INGRESSO
(
  FIN_COD_FORMA NUMERIC(2) not null,
  FIN_DESCRICAO CHARACTER VARYING(35) not null
);
alter table FORMAS_INGRESSO
  add constraint FIN_PK primary key (FIN_COD_FORMA);

--Creating table ALUNOS
--=====================
create table ALUNOS
(
  ALU_MATRICULA         CHARACTER VARYING(9) not null,
  ALU_APV_NUM_INSCRICAO CHARACTER VARYING(7) not null,
  ALU_CCU_CUR_COD_CURSO NUMERIC(8) not null,
  ALU_CCU_COD_CURRICULO NUMERIC(5) not null,
  ALU_AEC_COD_AREA      NUMERIC(2),
  ALU_CAMPUS            NUMERIC(1) not null,
  ALU_NOME              CHARACTER VARYING(40),
  ALU_ESTADO_CIVIL      NUMERIC(1),
  ALU_FILIACAO          CHARACTER VARYING(50),
  ALU_SEXO              NUMERIC(1),
  ALU_DT_NASC           DATE,
  ALU_CPF               CHARACTER VARYING(15),
  ALU_ENDERECO          CHARACTER VARYING(50),
  ALU_CEP               CHARACTER VARYING(9),
  ALU_FONE              CHARACTER VARYING(15),
  ALU_NATURALIDADE      CHARACTER VARYING(15),
  ALU_NACIONALIDADE     CHARACTER VARYING(15),
  ALU_RG_NUMERO         CHARACTER VARYING(11),
  ALU_RG_ORGAO          CHARACTER VARYING(6),
  ALU_RG_ESTADO         CHARACTER VARYING(2),
  ALU_RG_DATA_EXP       DATE,
  ALU_SM_NUMERO         CHARACTER VARYING(18),
  ALU_SM_TIPO_DOC       CHARACTER VARYING(15),
  ALU_SM_SERIE          CHARACTER VARYING(1),
  ALU_SM_ORGAO          CHARACTER VARYING(5),
  ALU_SM_DT_EXP         DATE,
  ALU_TIT_NUMERO        CHARACTER VARYING(15),
  ALU_TIT_ZONA          CHARACTER VARYING(3),
  ALU_TIT_ESTADO        CHAR(2),
  ALU_SITUACAO          CHAR(1) not null,
  ALU_FORMA_EVASAO      NUMERIC(2),
  ALU_ANO_EVASA         NUMERIC(4),
  ALU_PERIODO_EVASAO    NUMERIC(1),
  ALU_FORMA_INGRESSO    NUMERIC(2) not null,
  ALU_DT_CONCLUSAO      DATE,
  ALU_DT_EXP_DIPLOMA    DATE,
  ALU_ANO_INGRESSO      NUMERIC(4) not null,
  ALU_SENHA             CHARACTER VARYING(8),
  ALU_PERIODO_INGRESSO  NUMERIC(1) not null,
  ALU_DT_ENC            DATE,
  ALU_BAIRRO            CHARACTER VARYING(20),
  ALU_COMPLEMENTO       CHARACTER VARYING(20),
  ALU_CIDADE            CHARACTER VARYING(40),
  ALU_ESTADO            CHARACTER VARYING(2),
  ALU_EMAIL             CHARACTER VARYING(40),
  ALU_EMAIL2            CHARACTER VARYING(40),
  ALU_FONE2             CHARACTER VARYING(15),
  ALU_FILIACAO2         CHARACTER VARYING(40),
  ALU_ENSINO_MEDIO      NUMERIC(1),
  ALU_COR_PELE          NUMERIC(1),
  ALU_DEFICIENCIA       NUMERIC(1) not null,
  ALU_DT_ATUALIZACAO    DATE,
  ALU_DICA_SENHA        CHARACTER VARYING(40)
);
comment on column ALUNOS.ALU_MATRICULA
  is 'o 5 campo da matricula indica a area do aluno: 1- tecnologia; 2- saude; 3, 4, 5, 6, 7 - humanas; 9 e 0???';
comment on column ALUNOS.ALU_ESTADO_CIVIL
  is '1-solteiro;2-casado;3-desquitado;4-viúvo,5-divorciado;6-outros';
comment on column ALUNOS.ALU_SEXO
  is '1-Masculino; 2 -Feminino';
comment on column ALUNOS.ALU_FORMA_EVASAO
  is '1-CONCLUSAO/2-TRANSFERENCIA/3-FALECIMENTO/4-ABANDONO/5-CANCELAMENTO/6-MUDANCA CURSO/7-DECISAO JUDICIAL/8-SOLICITACAO DO ALUNO/9-SUSPENSAO TEMPORARIA/10-FALTA MATR PREVIA/11-PEC-RP RES.36/98/12-ConclusãoPIANI/13-MOBILIDADE INTERNA';
comment on column ALUNOS.ALU_FORMA_INGRESSO
  is '1-VESTIBULAR / 2-TRANSFERENCIA / 3-CONVENIO / 4-MUDANCA DE CAMPUS-CURSO / 5-GRADUADO / 6-VESTIBULAR-MUDANCA DE CURSO / 7-TRANSFERENCIA-MUDANCA DE CURSO / 8-CONVENIO-MUDANCA DE CURSO / 9-TRANSFERENCIA EX-OFICIO / 10-TRANSFERENCIA POR FORCA LIMINAR / 11-TRANSFERENCIA POR FORCA SENTENCA / 12-PEC / 13- REINGRESSO / 14-DISCIPLINAS ISOLADAS(ESPECIAL) / 15-PROGRAMA PIANI / 16-VESTIBULAR 2 / 17-PROGRAMA DE MOBILIDADE ESTUDANTIL / 18-PEC-MSC / 19-REINGRESSO POR DECISAO DO CONSEPE/20-MOBILIDADE INTERNA/21-DECISAO CONSEPE-REC. PROC. SELETIVO';
comment on column ALUNOS.ALU_ENSINO_MEDIO
  is '1 = publico; 2 = particular; 3 = publico e particular';
comment on column ALUNOS.ALU_COR_PELE
  is '1 = nao declarada; 2 = branca; 3 = negra; 4 = amarelo; 5 = pardo; 6 = indigena';
comment on column ALUNOS.ALU_DEFICIENCIA
  is '0 - Nao declarado
1 - Nenhuma
2 - Visual (usuário de Braille)
3 - Auditiva (Parcial)
4 - Física
5 - Outras/Mais de uma
6 - Visual (visão sub-normal)
7 - Visual (usuário de óculos)
8 - Usuário de LIBRAS (Surdo)
';
comment on column ALUNOS.ALU_DICA_SENHA
  is 'Instruções cadastradas pelo
próprio aluno para auxiliar a lembrança da senha cadastrada.';
alter table ALUNOS
  add constraint ALU_PK primary key (ALU_MATRICULA);
alter table ALUNOS
  add constraint ALU_AEC_FK foreign key (ALU_CCU_CUR_COD_CURSO, ALU_CCU_COD_CURRICULO, ALU_AEC_COD_AREA)
  references AREAS_ESPEC_CURRICULOS (AEC_CCU_CUR_COD_CURSO, AEC_CCU_COD_CURRICULO, AEC_COD_AREA);
alter table ALUNOS
  add constraint ALU_CAM_FK foreign key (ALU_CAMPUS)
  references CAMPI (CAM_CAMPUS);
alter table ALUNOS
  add constraint ALU_CCU_FK foreign key (ALU_CCU_CUR_COD_CURSO, ALU_CCU_COD_CURRICULO)
  references CURRICULOS_CURSOS (CCU_CUR_COD_CURSO, CCU_COD_CURRICULO);
alter table ALUNOS
  add constraint ALU_FIN_FK foreign key (ALU_FORMA_INGRESSO)
  references FORMAS_INGRESSO (FIN_COD_FORMA);
alter table ALUNOS
  add constraint ALU_DEFICIENCIA
  check (ALU_DEFICIENCIA IN (0, 1, 2, 3, 4, 5, 6, 7, 8));
alter table ALUNOS
  add constraint ALU_ESTADO_CIVIL_CK
  check (Alu_Estado_Civil BETWEEN 0 AND 6);
alter table ALUNOS
  add constraint ALU_EVASAO_CK
  check (Alu_Forma_Evasao         BETWEEN 0 AND 13);
alter table ALUNOS
  add constraint ALU_SEXO_CK
  check (Alu_Sexo BETWEEN 1 AND 2);
alter table ALUNOS
  add constraint ALU_SITUACAO_CK
  check (Alu_Situacao IN ('A', 'I'));
create index ALU_CCU_INDX on ALUNOS (ALU_CCU_CUR_COD_CURSO, ALU_CCU_COD_CURRICULO);
create index ALU_CUR_IDX on ALUNOS (ALU_CCU_CUR_COD_CURSO);
create index ALU_SIT_IDX on ALUNOS (ALU_SITUACAO);

--Creating table AREAS_CONHECIMENTO
--=================================
create table AREAS_CONHECIMENTO
(
  ARC_CUR_COD_CURSO NUMERIC(8) not null,
  ARC_TAX_CODIGO    NUMERIC(4) not null,
  ARC_CODIGO        CHARACTER VARYING(10) not null,
  ARC_DESCRICAO     CHARACTER VARYING(60) not null
);
alter table AREAS_CONHECIMENTO
  add constraint ARC_PK primary key (ARC_CUR_COD_CURSO, ARC_TAX_CODIGO);

--Creating table TIPOS_DISCIPLINA
--===============================
create table TIPOS_DISCIPLINA
(
  TDI_COD_TIPO  NUMERIC(2) not null,
  TDI_DESCRICAO CHARACTER VARYING(60) not null
);
alter table TIPOS_DISCIPLINA
  add constraint TDI_PK primary key (TDI_COD_TIPO);

--Creating table DISCIPLINAS
--==========================
create table DISCIPLINAS
(
  DIS_DISCIPLINA       NUMERIC(7) not null,
  DIS_DESCRICAO        CHARACTER VARYING(40),
  DIS_CH_TEORICA_SEM   NUMERIC(3),
  DIS_CH_PRATICA_SEM   NUMERIC(3),
  DIS_QTD_CR           NUMERIC(2),
  DIS_QTD_CH           NUMERIC(3),
  DIS_MEDIA_APROVACAO  NUMERIC(5,2),
  DIS_CH_TEORICA_MIN   NUMERIC(3),
  DIS_CH_PRATICA_MIN   NUMERIC(3),
  DIS_CH_TEORICA_MAX   NUMERIC(3),
  DIS_CH_PRATICA_MAX   NUMERIC(3),
  DIS_NUM_SEMANAS      NUMERIC(2),
  DIS_SET_COD_SETOR    CHARACTER VARYING(8),
  DIS_STATUS           CHAR(1),
  DIS_INDICADOR_PADRAO CHAR(1),
  DIS_CONTABILIZA_CRE  CHAR(1),
  DIS_TDI_COD_TIPO     NUMERIC(2)
);
comment on column DISCIPLINAS.DIS_TDI_COD_TIPO
  is '-- 0 NORMAL
-- 1 ESTÁGIO/INTERNATO
-- 2 MONOGRAFIA
-- 3 PRÁTICA DE ENSINO
-- 4 TCC
-- 5 MÓDULO

Disciplinas do tipo 5, possuem entrada na tabela DEPTOS_MODULO para especificar a CH em cada Depto.';
alter table DISCIPLINAS
  add constraint DIS_PK primary key (DIS_DISCIPLINA);
alter table DISCIPLINAS
  add constraint DIS_SET_FK foreign key (DIS_SET_COD_SETOR)
  references SETORES (SET_COD_SETOR);
alter table DISCIPLINAS
  add constraint DIS_TDI_FK foreign key (DIS_TDI_COD_TIPO)
  references TIPOS_DISCIPLINA (TDI_COD_TIPO);
alter table DISCIPLINAS
  add constraint DIS_CONTABILIZA_CRE_CK
  check (DIS_CONTABILIZA_CRE IN ('S','N'));
create index DIS_SET_IDX on DISCIPLINAS (DIS_SET_COD_SETOR);

--Creating table TURMAS
--=====================
create table TURMAS
(
  TUR_TURMA          CHARACTER VARYING(2) not null,
  TUR_DIS_DISCIPLINA NUMERIC(7) not null,
  TUR_ANO            NUMERIC(4) not null,
  TUR_PERIODO        NUMERIC(1) not null,
  TUR_NUM_NOTAS      NUMERIC(1),
  TUR_QTD_CR         NUMERIC(2),
  TUR_QTD_CH         NUMERIC(3),
  TUR_PLANO_CURSO    CHARACTER VARYING(1024),
  TUR_DATA_INICIO    DATE,
  TUR_DATA_TERMINO   DATE
);
comment on column TURMAS.TUR_PLANO_CURSO
  is 'Plano de curso para a turma (conteúdo
geral a ser ministrado)';
comment on column TURMAS.TUR_DATA_INICIO
  is 'Data de início da turma. Opcional para
cursos que adotam o conceito de Módulos. A análise de choque de horários, para fins
da matrícula, considera esse dado, pois módulos possuem a característica de
sequenciamento de disciplinas, num mesmo horário, num mesmo período letivo.';
comment on column TURMAS.TUR_DATA_TERMINO
  is 'Data de término da turma. Opcional
para cursos que adotam o conceito de Módulos. A análise de choque de horários, para
fins da matrícula, considera esse dado, pois módulos possuem a característica de
sequenciamento de disciplinas, num mesmo horário, num mesmo período letivo.';
alter table TURMAS
  add constraint TUR_PK primary key (TUR_ANO, TUR_PERIODO, TUR_DIS_DISCIPLINA, TUR_TURMA);
alter table TURMAS
  add constraint TUR_DIS_FK foreign key (TUR_DIS_DISCIPLINA)
  references DISCIPLINAS (DIS_DISCIPLINA);
alter table TURMAS
  add constraint TUR_PERIODO_CK
  check (Tur_Periodo BETWEEN 0 AND 2);

--Creating table AULAS_TURMA
--==========================
create table AULAS_TURMA
(
  AUT_AULA                     NUMERIC(3) not null,
  AUT_DATA_HORA_PREVISTA       DATE,
  AUT_DATA_HORA_REALIZADA      DATE,
  AUT_DURACAO                  NUMERIC(5,2),
  AUT_CONTEUDO_PREVISTO        CHARACTER VARYING(256),
  AUT_CONTEUDO_MINISTRADO      CHARACTER VARYING(256),
  AUT_BIBLIOGRAFIA_RECOMENDADA CHARACTER VARYING(256),
  AUT_OBS_PROFESSOR            CHARACTER VARYING(256),
  AUT_TUR_ANO                  NUMERIC(4) not null,
  AUT_TUR_PERIODO              NUMERIC(1) not null,
  AUT_TUR_DIS_DISCIPLINA       NUMERIC(7) not null,
  AUT_TUR_TURMA                CHARACTER VARYING(2) not null
);
comment on table AULAS_TURMA
  is 'Contém a programação de aulas e o registro de cada
uma para uma determinada turma';
comment on column AULAS_TURMA.AUT_AULA
  is 'Número identificador da aula no
curso/turma';
comment on column AULAS_TURMA.AUT_DATA_HORA_PREVISTA
  is 'Data e hora prevista para
início da aula';
comment on column AULAS_TURMA.AUT_DATA_HORA_REALIZADA
  is 'Data e hora real de início
da aula';
comment on column AULAS_TURMA.AUT_DURACAO
  is 'Duração (em minutos) da aula';
comment on column AULAS_TURMA.AUT_CONTEUDO_PREVISTO
  is 'Conteúdo programático
previsto para a aula';
comment on column AULAS_TURMA.AUT_CONTEUDO_MINISTRADO
  is 'Conteúdo programático
ministrado na aula';
comment on column AULAS_TURMA.AUT_BIBLIOGRAFIA_RECOMENDADA
  is 'Bibliografia
recomendada para o conteúdo ministrado';
comment on column AULAS_TURMA.AUT_OBS_PROFESSOR
  is 'Observações gerais do professor
sobre a aula ministrada';
alter table AULAS_TURMA
  add constraint XPKAULAS_TURMA primary key (AUT_TUR_ANO, AUT_TUR_PERIODO, AUT_TUR_DIS_DISCIPLINA, AUT_TUR_TURMA, AUT_AULA);
alter table AULAS_TURMA
  add constraint R_67 foreign key (AUT_TUR_ANO, AUT_TUR_PERIODO, AUT_TUR_DIS_DISCIPLINA, AUT_TUR_TURMA)
  references TURMAS (TUR_ANO, TUR_PERIODO, TUR_DIS_DISCIPLINA, TUR_TURMA);
alter table AULAS_TURMA
  add constraint TUR_PERIODO_CK8
  check (AUT_TUR_PERIODO BETWEEN 0 AND 2);
create index XIF1AULAS_TURMA on AULAS_TURMA (AUT_TUR_ANO, AUT_TUR_PERIODO, AUT_TUR_DIS_DISCIPLINA, AUT_TUR_TURMA);

--Creating table AVALIACOES_TURMA
--===============================
create table AVALIACOES_TURMA
(
  AVT_AVALIACAO           NUMERIC(2) not null,
  AVT_DATA_HORA_PREVISTA  DATE,
  AVT_DATA_HORA_REALIZADA DATE,
  AVT_PESO                NUMERIC(5,2),
  AVT_TUR_ANO             NUMERIC(4) not null,
  AVT_TUR_PERIODO         NUMERIC(1) not null,
  AVT_TUR_DIS_DISCIPLINA  NUMERIC(7) not null,
  AVT_TUR_TURMA           CHARACTER VARYING(2) not null,
  AVT_TIPO_AVALIACAO      NUMERIC(2)
);
comment on table AVALIACOES_TURMA
  is 'Contém as definições de avaliação por notas da
turma. Para cada avaliação há a previsão e confirmação de data e hora de realização
e o peso no cálculo da média final.';
comment on column AVALIACOES_TURMA.AVT_AVALIACAO
  is 'Número da avaliação/prova';
comment on column AVALIACOES_TURMA.AVT_DATA_HORA_PREVISTA
  is 'Data e hora prevista
para a avaliação';
comment on column AVALIACOES_TURMA.AVT_DATA_HORA_REALIZADA
  is 'Data e hora em que
efetivamente houve a avaliação';
comment on column AVALIACOES_TURMA.AVT_PESO
  is 'Peso (fator moderador) para cálculo
da média final dos alunos na turma';
comment on column AVALIACOES_TURMA.AVT_TIPO_AVALIACAO
  is 'Indica o tipo de nota registrada:
1-Exercício
2-Prova final
3-2a. época
5-Bimestre';
alter table AVALIACOES_TURMA
  add constraint XPKAVALIACOES_TURMA primary key (AVT_TUR_TURMA, AVT_TUR_ANO, AVT_TUR_PERIODO, AVT_TUR_DIS_DISCIPLINA, AVT_AVALIACAO);
alter table AVALIACOES_TURMA
  add constraint R_66 foreign key (AVT_TUR_ANO, AVT_TUR_PERIODO, AVT_TUR_DIS_DISCIPLINA, AVT_TUR_TURMA)
  references TURMAS (TUR_ANO, TUR_PERIODO, TUR_DIS_DISCIPLINA, TUR_TURMA);
alter table AVALIACOES_TURMA
  add constraint AVT_TIPO_AVALIACAO_CK
  check (AVT_TIPO_AVALIACAO IN (1, 2, 3, 5));
alter table AVALIACOES_TURMA
  add constraint TUR_PERIODO_CK7
  check (AVT_TUR_PERIODO BETWEEN 0 AND 2);
create index XIF1AVALIACOES_TURMA on AVALIACOES_TURMA (AVT_TUR_ANO, AVT_TUR_PERIODO, AVT_TUR_DIS_DISCIPLINA, AVT_TUR_TURMA);

--Creating table AVALIACOES_BIMESTRAIS
--====================================
create table AVALIACOES_BIMESTRAIS
(
  AVB_AVT_TUR_TURMA          CHARACTER VARYING(2) not null,
  AVB_AVT_TUR_ANO            NUMERIC(4) not null,
  AVB_AVT_TUR_PERIODO        NUMERIC(1) not null,
  AVB_AVT_TUR_DIS_DISCIPLINA NUMERIC(7) not null,
  AVB_AVT_AVALIACAO          NUMERIC(2) not null,
  AVB_NUMERO                 NUMERIC(4) not null,
  AVB_DATA_HORA_PREVISTA     DATE,
  AVB_DATA_HORA_REALIZADA    DATE,
  AVB_PESO                   NUMERIC(5,2),
  AVB_TIPO                   CHARACTER VARYING(1)
);
comment on table AVALIACOES_BIMESTRAIS
  is 'Armazena o planejamento de avaliações entre bimestres (exercícios diversos, trabalhos etc) que resultarão em notas parciais. O resultado de cada conjunto dessas notas (média do bimestre) corresponde a uma das avaliações previstas em AVALIACOES_TURMA';
comment on column AVALIACOES_BIMESTRAIS.AVB_AVT_AVALIACAO
  is 'Número da avaliação/prova';
comment on column AVALIACOES_BIMESTRAIS.AVB_NUMERO
  is 'Número da avaliação no bimestre';
comment on column AVALIACOES_BIMESTRAIS.AVB_DATA_HORA_PREVISTA
  is 'Data e hora prevista para realização da avaliação';
comment on column AVALIACOES_BIMESTRAIS.AVB_DATA_HORA_REALIZADA
  is 'Data e hora da realização da avaliação';
comment on column AVALIACOES_BIMESTRAIS.AVB_PESO
  is 'Peso atribuído à avaliação para cálculo automático da média bimestral';
comment on column AVALIACOES_BIMESTRAIS.AVB_TIPO
  is 'Indica se é exercício ou recuperação';
alter table AVALIACOES_BIMESTRAIS
  add constraint XPKAVALIACOES_BIMESTRAIS primary key (AVB_AVT_TUR_TURMA, AVB_AVT_TUR_ANO, AVB_AVT_TUR_PERIODO, AVB_AVT_TUR_DIS_DISCIPLINA, AVB_AVT_AVALIACAO, AVB_NUMERO);
alter table AVALIACOES_BIMESTRAIS
  add constraint R_83 foreign key (AVB_AVT_TUR_TURMA, AVB_AVT_TUR_ANO, AVB_AVT_TUR_PERIODO, AVB_AVT_TUR_DIS_DISCIPLINA, AVB_AVT_AVALIACAO)
  references AVALIACOES_TURMA (AVT_TUR_TURMA, AVT_TUR_ANO, AVT_TUR_PERIODO, AVT_TUR_DIS_DISCIPLINA, AVT_AVALIACAO) on delete set null;
alter table AVALIACOES_BIMESTRAIS
  add constraint TIPO_AVALIAÇÃO2
  check (AVB_TIPO IN (1, 2));
alter table AVALIACOES_BIMESTRAIS
  add constraint TUR_PERIODO_CK109
  check (AVB_AVT_TUR_PERIODO BETWEEN 0 AND 2);
create index XIF1AVALIACOES_BIMESTRAIS on AVALIACOES_BIMESTRAIS (AVB_AVT_TUR_TURMA, AVB_AVT_TUR_ANO, AVB_AVT_TUR_PERIODO, AVB_AVT_TUR_DIS_DISCIPLINA, AVB_AVT_AVALIACAO);

--Creating table LOCAIS_DISPENSA
--==============================
create table LOCAIS_DISPENSA
(
  LDS_COD_LOCAL_DISPENSA NUMERIC(4) not null,
  LDS_DESCRICAO          CHARACTER VARYING(80) not null
);
alter table LOCAIS_DISPENSA
  add constraint LDS_PK primary key (LDS_COD_LOCAL_DISPENSA);

--Creating table MATRICULAS
--=========================
create table MATRICULAS
(
  MAT_ALU_MATRICULA          CHARACTER VARYING(9) not null,
  MAT_TUR_TURMA              CHARACTER VARYING(2),
  MAT_TUR_DIS_DISCIPLINA     NUMERIC(7) not null,
  MAT_TUR_ANO                NUMERIC(4) not null,
  MAT_TUR_PERIODO            NUMERIC(1) not null,
  MAT_SOM_TRA_NUM_TRANSACAO  NUMERIC(9) not null,
  MAT_SITUACAO               NUMERIC(1) not null,
  MAT_IMA_TRA_NUM_TRANSACAO  NUMERIC(9),
  MAT_TIPO_MATRICULA         NUMERIC(1) not null,
  MAT_LDS_COD_LOCAL_DISPENSA NUMERIC(4),
  MAT_MEDIA_FINAL            NUMERIC(5,2),
  MAT_COD_ID                 NUMERIC(10,2),
  MAT_CALCULO_MEDIA          CHARACTER VARYING(1)
);
comment on column MATRICULAS.MAT_SITUACAO
  is 'EM_CURSO=1;INTERROMPIDO=2;APROVADO=3;REPROVADO=4;REPROV_FALTA=5;PRESENTE=6';
comment on column MATRICULAS.MAT_TIPO_MATRICULA
  is 'NORMAL=1;PENDENCIA=2;EXTRA_CURRICULAR=3;DISPENSA=4';
comment on column MATRICULAS.MAT_CALCULO_MEDIA
  is 'Indica o tipo de cálculo da média final do aluno na disciplina.
Manual - lançada diretamente pelo Depto/Prof
Automática - lançada pelo SCA, de acordo com as
notas registradas em NOTAS_MATRICULA';
alter table MATRICULAS
  add constraint MAT_PK primary key (MAT_ALU_MATRICULA, MAT_TUR_DIS_DISCIPLINA, MAT_TUR_ANO, MAT_TUR_PERIODO);
alter table MATRICULAS
  add constraint MAT_ALU_FK foreign key (MAT_ALU_MATRICULA)
  references ALUNOS (ALU_MATRICULA);
alter table MATRICULAS
  add constraint MAT_LDS_FK foreign key (MAT_LDS_COD_LOCAL_DISPENSA)
  references LOCAIS_DISPENSA (LDS_COD_LOCAL_DISPENSA);
alter table MATRICULAS
  add constraint MANUAL_OU_AUTOMATICA
  check (MAT_CALCULO_MEDIA IN ('M', 'A'));
alter table MATRICULAS
  add constraint MAT_SITUACAO_CK
  check (mat_situacao between 1 and 6);
alter table MATRICULAS
  add constraint MAT_TUR_PERIODO_CK
  check (Mat_Tur_Periodo  BETWEEN 0 AND 2);
create index MAT_ALU_IDX on MATRICULAS (MAT_ALU_MATRICULA);
create index MAT_INDX on MATRICULAS (MAT_TUR_ANO, MAT_TUR_PERIODO, MAT_TUR_DIS_DISCIPLINA, MAT_TUR_TURMA);

--Creating table CALCULO_MEDIA
--============================
create table CALCULO_MEDIA
(
  CLM_MAT_ALU_MATRICULA      CHARACTER VARYING(9) not null,
  CLM_MAT_TUR_DIS_DISCIPLINA NUMERIC(7) not null,
  CLM_MAT_TUR_ANO            NUMERIC(4) not null,
  CLM_MAT_TUR_PERIODO        NUMERIC(1) not null,
  CLM_MEDIA_EXERCICIOS       NUMERIC(5,2),
  CLM_PROVA_FINAL            NUMERIC(5,2),
  CLM_MEDIA_FINAL            NUMERIC(5,2),
  CLM_DATA_CALCULO           DATE not null,
  CLM_DESCRICAO              CHARACTER VARYING(60),
  CLM_SITUACAO_SUGERIDA      CHARACTER VARYING(60)
);
comment on table CALCULO_MEDIA
  is 'Contém o
detalhamento do cálculo automático da média final do aluno na disciplina.';
comment on column CALCULO_MEDIA.CLM_MEDIA_EXERCICIOS
  is 'Média
obtida pelo aluno nas notas de exercício';
comment on column CALCULO_MEDIA.CLM_PROVA_FINAL
  is 'Nota da prova final do aluno (se houver)';
comment on column CALCULO_MEDIA.CLM_MEDIA_FINAL
  is 'Média final obtida';
comment on column CALCULO_MEDIA.CLM_DATA_CALCULO
  is 'Data e hora de registro da média final na tabela MATRICULAS';
comment on column CALCULO_MEDIA.CLM_DESCRICAO
  is 'Descritivo da forma de cálculo';
comment on column CALCULO_MEDIA.CLM_SITUACAO_SUGERIDA
  is 'Indica se
o aluno deve ser aprovado por média, aprovado na
final, reprovado por nota ou reprovado por falta';
alter table CALCULO_MEDIA
  add constraint XPKCALCULO_MEDIA primary key (CLM_MAT_ALU_MATRICULA, CLM_MAT_TUR_DIS_DISCIPLINA, CLM_MAT_TUR_ANO, CLM_MAT_TUR_PERIODO, CLM_DATA_CALCULO);
alter table CALCULO_MEDIA
  add constraint R_79 foreign key (CLM_MAT_ALU_MATRICULA, CLM_MAT_TUR_DIS_DISCIPLINA, CLM_MAT_TUR_ANO, CLM_MAT_TUR_PERIODO)
  references MATRICULAS (MAT_ALU_MATRICULA, MAT_TUR_DIS_DISCIPLINA, MAT_TUR_ANO, MAT_TUR_PERIODO);
alter table CALCULO_MEDIA
  add constraint MAT_TUR_PERIODO_CK46
  check (CLM_MAT_TUR_PERIODO  BETWEEN 0 AND 2);
create index XIF2CALCULO_MEDIA on CALCULO_MEDIA (CLM_MAT_ALU_MATRICULA, CLM_MAT_TUR_DIS_DISCIPLINA, CLM_MAT_TUR_ANO, CLM_MAT_TUR_PERIODO);

--Creating table CANDIDATOS_SELECAO
--=================================
create table CANDIDATOS_SELECAO
(
  CSE_VGO_PRS_CODIGO    NUMERIC(8) not null,
  CSE_VGO_CUR_COD_CURSO NUMERIC(8) not null,
  CSE_ALU_MATRICULA     CHARACTER VARYING(9) not null,
  CSE_NUMERO_OPCAO      NUMERIC(2) not null,
  CSE_NOME              CHARACTER VARYING(60),
  CSE_REGRA_PRIORIDADE  NUMERIC(2),
  CSE_COEFICIENTE       NUMERIC(6,2),
  CSE_SITUACAO          NUMERIC(2),
  CSE_STATUS_INSCRICAO  CHARACTER VARYING(1),
  CSE_MOTIVO_REJEICAO   CHARACTER VARYING(2)
);
alter table CANDIDATOS_SELECAO
  add constraint CSE_PRS_FK foreign key (CSE_VGO_PRS_CODIGO)
  references PROCESSOS_SELETIVOS (PRS_CODIGO);
alter table CANDIDATOS_SELECAO
  add constraint CSE_STATUS_INSCRICAO_CK
  check (CSE_STATUS_INSCRICAO IN ('S','N'));

--Creating table DISCIPLINAS_CURRICULO
--====================================
create table DISCIPLINAS_CURRICULO
(
  DIC_CCU_CUR_COD_CURSO NUMERIC(8) not null,
  DIC_CCU_COD_CURRICULO NUMERIC(5) not null,
  DIC_DIS_DISCIPLINA    NUMERIC(7) not null,
  DIC_REGRA             NUMERIC(1) not null,
  DIC_AEC_COD_AREA      NUMERIC(2),
  DIC_SEMESTRE_IDEAL    NUMERIC(2),
  DIC_STATUS            CHAR(1),
  DIC_QTD_CH            NUMERIC(3),
  DIC_QTD_CR            NUMERIC(2)
);
alter table DISCIPLINAS_CURRICULO
  add constraint DIC_PK primary key (DIC_CCU_CUR_COD_CURSO, DIC_CCU_COD_CURRICULO, DIC_DIS_DISCIPLINA);
alter table DISCIPLINAS_CURRICULO
  add constraint DIC_CCU_FK foreign key (DIC_CCU_CUR_COD_CURSO, DIC_CCU_COD_CURRICULO)
  references CURRICULOS_CURSOS (CCU_CUR_COD_CURSO, CCU_COD_CURRICULO);
alter table DISCIPLINAS_CURRICULO
  add constraint DIC_DIS_FK foreign key (DIC_DIS_DISCIPLINA)
  references DISCIPLINAS (DIS_DISCIPLINA);
alter table DISCIPLINAS_CURRICULO
  add constraint DIC_REGRA_CK
  check (DiC_Regra BETWEEN 1 AND 4);

--Creating table CO_REQUISITOS_DISCIPLINA
--=======================================
create table CO_REQUISITOS_DISCIPLINA
(
  CRD_DIC_CCU_CUR_COD_CURSO NUMERIC(8) not null,
  CRD_DIC_CCU_COD_CURRICULO NUMERIC(5) not null,
  CRD_DIC_DIS_DISCIPLINA    NUMERIC(7) not null,
  CRD_DISCIPLINA_CO_REQ     NUMERIC(7) not null,
  CRD_OPERADOR              CHAR(2),
  CRD_ORDEM_PRIOR           NUMERIC(2) not null
);
alter table CO_REQUISITOS_DISCIPLINA
  add constraint CRD_DIC_FK foreign key (CRD_DIC_CCU_CUR_COD_CURSO, CRD_DIC_CCU_COD_CURRICULO, CRD_DIC_DIS_DISCIPLINA)
  references DISCIPLINAS_CURRICULO (DIC_CCU_CUR_COD_CURSO, DIC_CCU_COD_CURRICULO, DIC_DIS_DISCIPLINA);
alter table CO_REQUISITOS_DISCIPLINA
  add constraint CRD_DIC_FK2 foreign key (CRD_DIC_CCU_CUR_COD_CURSO, CRD_DIC_CCU_COD_CURRICULO, CRD_DISCIPLINA_CO_REQ)
  references DISCIPLINAS_CURRICULO (DIC_CCU_CUR_COD_CURSO, DIC_CCU_COD_CURRICULO, DIC_DIS_DISCIPLINA);
alter table CO_REQUISITOS_DISCIPLINA
  add constraint CRD_OPERADOR_CK
  check (CrD_Operador IN ('E', 'OU'));
create index CRD_INDX on CO_REQUISITOS_DISCIPLINA (CRD_DIC_CCU_CUR_COD_CURSO, CRD_DIC_CCU_COD_CURRICULO, CRD_DIC_DIS_DISCIPLINA);

--Creating table CURSOS_DATA_INICIO
--=================================
create table CURSOS_DATA_INICIO
(
  CDT_COD_CURSO       NUMERIC(8) not null,
  CDT_CUR_DESCRICAO   CHARACTER VARYING(40),
  CDT_DATA_INICIO     DATE,
  CDT_TIPO_CURSO      CHAR(1),
  CDT_CH_MIN_TOTAL    NUMERIC(7,2),
  CDT_CURSO_ASSOCIADO NUMERIC(8)
);
comment on table CURSOS_DATA_INICIO
  is 'Tabela usada para preenchimento do PingIfes. Deve ser preenchida com a CH do curriculo mais atual .';
alter table CURSOS_DATA_INICIO
  add constraint CDT_COD_CURSO_PRIMARY_KEY primary key (CDT_COD_CURSO);

--Creating table CURSOS_FATOS
--===========================
create table CURSOS_FATOS
(
  CFT_ANO                NUMERIC(4) not null,
  CFT_PERIODO            NUMERIC(1) not null,
  CFT_CURSO              NUMERIC(8) not null,
  CFT_TURNO              NUMERIC(1) not null,
  CFT_SEXO               NUMERIC(1) not null,
  CFT_FORMA_INGRESSO     NUMERIC(2) not null,
  CFT_MATRICULADOS       NUMERIC(4),
  CFT_ATIVOS             NUMERIC(4),
  CFT_EVADIDOS_GRADUADOS NUMERIC(4),
  CFT_EVADIDOS_TRANSFER  NUMERIC(4),
  CFT_EVADIDOS_ABANDONOS NUMERIC(4),
  CFT_EVADIDOS_OUTROS    NUMERIC(4),
  CFT_TRANC_TOTAL        NUMERIC(4),
  CFT_CH_CURSADOS        NUMERIC(7),
  CFT_CR_CURSADOS        NUMERIC(5),
  CFT_INGRESSANTES       NUMERIC(4)
);

--Creating table CURSOS_TURMA
--===========================
create table CURSOS_TURMA
(
  CUT_TUR_TURMA          CHARACTER VARYING(2) not null,
  CUT_TUR_DIS_DISCIPLINA NUMERIC(7) not null,
  CUT_TUR_ANO            NUMERIC(4) not null,
  CUT_TUR_PERIODO        NUMERIC(1) not null,
  CUT_CUR_COD_CURSO      NUMERIC(8) not null,
  CUT_VAGAS_DISPONIVEIS  NUMERIC(3),
  CUT_NUM_VAGAS          NUMERIC(3)
);
alter table CURSOS_TURMA
  add constraint CUT_PK primary key (CUT_TUR_ANO, CUT_TUR_PERIODO, CUT_TUR_DIS_DISCIPLINA, CUT_TUR_TURMA, CUT_CUR_COD_CURSO);
alter table CURSOS_TURMA
  add constraint CUT_CUR_FK foreign key (CUT_CUR_COD_CURSO)
  references CURSOS (CUR_COD_CURSO);
alter table CURSOS_TURMA
  add constraint CUT_TUR_FK foreign key (CUT_TUR_ANO, CUT_TUR_PERIODO, CUT_TUR_DIS_DISCIPLINA, CUT_TUR_TURMA)
  references TURMAS (TUR_ANO, TUR_PERIODO, TUR_DIS_DISCIPLINA, TUR_TURMA);
alter table CURSOS_TURMA
  add constraint CUT_TUR_PERIODO_CK
  check (CuT_Tur_Periodo between 0 and 2);

--Creating table DEPTOS_MODULO
--============================
create table DEPTOS_MODULO
(
  DPM_CH             NUMERIC(4),
  DPM_DESCRICAO      CHARACTER VARYING(120),
  DPM_DIS_DISCIPLINA NUMERIC(7) not null,
  DPM_SET_COD_SETOR  CHARACTER VARYING(8) not null
);
comment on table DEPTOS_MODULO
  is 'Contém a relação de departamentos que ministram um módulo.';
comment on column DEPTOS_MODULO.DPM_CH
  is 'Carga horária específica do departamento no módulo';
comment on column DEPTOS_MODULO.DPM_DESCRICAO
  is 'Descrição do papel do departamento no módulo';
alter table DEPTOS_MODULO
  add constraint XPKDEPTOS_MODULO primary key (DPM_SET_COD_SETOR, DPM_DIS_DISCIPLINA);
alter table DEPTOS_MODULO
  add constraint R_80 foreign key (DPM_DIS_DISCIPLINA)
  references DISCIPLINAS (DIS_DISCIPLINA);
alter table DEPTOS_MODULO
  add constraint R_81 foreign key (DPM_SET_COD_SETOR)
  references SETORES (SET_COD_SETOR);
create index XIF1DEPTOS_MODULO on DEPTOS_MODULO (DPM_DIS_DISCIPLINA);
create index XIF2DEPTOS_MODULO on DEPTOS_MODULO (DPM_SET_COD_SETOR);

--Creating table DETALHES_MATRICULA_AUTOMATICA
--============================================
create table DETALHES_MATRICULA_AUTOMATICA
(
  TMA_PMA_CODIGO NUMERIC(6) not null,
  TMA_TURMA      CHARACTER VARYING(2) not null,
  TMA_DISCIPLINA NUMERIC(7) not null,
  TMA_MATRICULA  NUMERIC(9) not null,
  TMA_MENSAGEM   CHARACTER VARYING(40)
);
comment on table DETALHES_MATRICULA_AUTOMATICA
  is 'Contém todos os descritivos das tentativas de matrícula realizadas em cada ocorrência';
comment on column DETALHES_MATRICULA_AUTOMATICA.TMA_PMA_CODIGO
  is 'Identificador único da solicitação de matrícula automática';
comment on column DETALHES_MATRICULA_AUTOMATICA.TMA_TURMA
  is 'Turma com tentativa de matrícula';
comment on column DETALHES_MATRICULA_AUTOMATICA.TMA_DISCIPLINA
  is 'Disciplina com tentativa de matrícula';
comment on column DETALHES_MATRICULA_AUTOMATICA.TMA_MATRICULA
  is 'Matrícula do aluno';
comment on column DETALHES_MATRICULA_AUTOMATICA.TMA_MENSAGEM
  is 'Mensagem de retorno do PTCA';
alter table DETALHES_MATRICULA_AUTOMATICA
  add constraint XPKDETALHES_MATRICULA_AUTOMATI primary key (TMA_PMA_CODIGO, TMA_TURMA, TMA_DISCIPLINA, TMA_MATRICULA);
alter table DETALHES_MATRICULA_AUTOMATICA
  add constraint R_82 foreign key (TMA_PMA_CODIGO)
  references PEDIDOS_MATRICULA_AUTOMATICA (PMA_CODIGO);
create index XIF1DETALHES_MATRICULA_AUTOMAT on DETALHES_MATRICULA_AUTOMATICA (TMA_PMA_CODIGO);

--Creating table ELEITORES_2008
--=============================
create table ELEITORES_2008
(
  ELE_MATRICULA       CHARACTER VARYING(11) not null,
  ELE_NOME            CHARACTER VARYING(60) not null,
  ELE_TIPO            CHAR(1) not null,
  ELE_DT_NASC         DATE,
  ELE_CPF             CHARACTER VARYING(15),
  ELE_RG_NUMERO       CHARACTER VARYING(20),
  ELE_RN              CHARACTER VARYING(9),
  ELE_COD_SETOR       CHARACTER VARYING(8),
  ELE_DESC_SETOR      CHARACTER VARYING(60),
  ELE_CAMPUS          NUMERIC(1),
  ELE_COD_CURSO       NUMERIC(8),
  ELE_DESC_CURSO      CHARACTER VARYING(60),
  ELE_SERIE_CURSO     CHARACTER VARYING(4),
  ELE_DATA_INGRESSO   DATE,
  ELE_CENTRO          CHARACTER VARYING(8) not null,
  ELE_SECAO_ELEITORAL CHARACTER VARYING(4)
);
comment on column ELEITORES_2008.ELE_MATRICULA
  is 'IDENTIFICACAO UNICA';
comment on column ELEITORES_2008.ELE_TIPO
  is 'P-PROFESSOR, F-FUNCIONARIO, A-ALUNO, E-EAD';
comment on column ELEITORES_2008.ELE_RN
  is 'REGISTRO DE NASCIMENTO';
alter table ELEITORES_2008
  add constraint PK_ELE_MATRICULA primary key (ELE_MATRICULA);

--Creating table FALTAS_AULA
--==========================
create table FALTAS_AULA
(
  FTA_MAT_ALU_MATRICULA      CHARACTER VARYING(9) not null,
  FTA_MAT_TUR_DIS_DISCIPLINA NUMERIC(7) not null,
  FTA_MAT_TUR_ANO            NUMERIC(4) not null,
  FTA_MAT_TUR_PERIODO        NUMERIC(1) not null,
  FTA_AUT_TUR_ANO            NUMERIC(4) not null,
  FTA_AUT_TUR_PERIODO        NUMERIC(1) not null,
  FTA_AUT_TUR_DIS_DISCIPLINA NUMERIC(7) not null,
  FTA_AUT_TUR_TURMA          CHARACTER VARYING(2) not null,
  FTA_AUT_AULA               NUMERIC(3) not null,
  FTA_OBS_PROFESSOR          CHARACTER VARYING(256),
  FTA_DATA_HORA_REGISTRO     DATE
);
comment on table FALTAS_AULA
  is 'Registros de falta dos alunos no curso/turma';
comment on column FALTAS_AULA.FTA_AUT_AULA
  is 'Número identificador da aula no
curso/turma';
comment on column FALTAS_AULA.FTA_OBS_PROFESSOR
  is 'Observações gerais do professor
sobre o registro de falta do aluno';
comment on column FALTAS_AULA.FTA_DATA_HORA_REGISTRO
  is 'Data e hora do registro de
falta do aluno';
alter table FALTAS_AULA
  add constraint XPKFALTAS_AULA primary key (FTA_AUT_TUR_TURMA, FTA_AUT_TUR_DIS_DISCIPLINA, FTA_AUT_TUR_ANO, FTA_AUT_TUR_PERIODO, FTA_AUT_AULA, FTA_MAT_ALU_MATRICULA, FTA_MAT_TUR_DIS_DISCIPLINA, FTA_MAT_TUR_ANO, FTA_MAT_TUR_PERIODO);
alter table FALTAS_AULA
  add constraint R_69 foreign key (FTA_MAT_ALU_MATRICULA, FTA_MAT_TUR_DIS_DISCIPLINA, FTA_MAT_TUR_ANO, FTA_MAT_TUR_PERIODO)
  references MATRICULAS (MAT_ALU_MATRICULA, MAT_TUR_DIS_DISCIPLINA, MAT_TUR_ANO, MAT_TUR_PERIODO);
alter table FALTAS_AULA
  add constraint R_71 foreign key (FTA_AUT_TUR_ANO, FTA_AUT_TUR_PERIODO, FTA_AUT_TUR_DIS_DISCIPLINA, FTA_AUT_TUR_TURMA, FTA_AUT_AULA)
  references AULAS_TURMA (AUT_TUR_ANO, AUT_TUR_PERIODO, AUT_TUR_DIS_DISCIPLINA, AUT_TUR_TURMA, AUT_AULA);
alter table FALTAS_AULA
  add constraint MAT_TUR_PERIODO_CK8
  check (FTA_MAT_TUR_PERIODO  BETWEEN 0 AND 2);
alter table FALTAS_AULA
  add constraint TUR_PERIODO_CK10
  check (FTA_AUT_TUR_PERIODO BETWEEN 0 AND 2);
create index XIF1FALTAS_AULA on FALTAS_AULA (FTA_MAT_ALU_MATRICULA, FTA_MAT_TUR_DIS_DISCIPLINA, FTA_MAT_TUR_ANO, FTA_MAT_TUR_PERIODO);
create index XIF2FALTAS_AULA on FALTAS_AULA (FTA_AUT_TUR_ANO, FTA_AUT_TUR_PERIODO, FTA_AUT_TUR_DIS_DISCIPLINA, FTA_AUT_TUR_TURMA, FTA_AUT_AULA);

--Creating table SALAS
--====================
create table SALAS
(
  SAL_COD_SALA      CHARACTER VARYING(10) not null,
  SAL_SET_COD_SETOR CHARACTER VARYING(8) not null,
  SAL_DESCRICAO     CHARACTER VARYING(25)
);
alter table SALAS
  add constraint SAL_PK primary key (SAL_COD_SALA);
alter table SALAS
  add constraint SAL_SET_FK foreign key (SAL_SET_COD_SETOR)
  references SETORES (SET_COD_SETOR);

--Creating table HORARIOS_TURMA
--=============================
create table HORARIOS_TURMA
(
  HOT_TUR_TURMA          CHARACTER VARYING(2) not null,
  HOT_TUR_DIS_DISCIPLINA NUMERIC(7) not null,
  HOT_TUR_ANO            NUMERIC(4) not null,
  HOT_TUR_PERIODO        NUMERIC(1) not null,
  HOT_DIA_SEMANA         NUMERIC(1) not null,
  HOT_HORA_INICIO        NUMERIC(4) not null,
  HOT_HORA_TERMINO       NUMERIC(4),
  HOT_SAL_COD_SALA       CHARACTER VARYING(10) not null
);
alter table HORARIOS_TURMA
  add constraint HOT_PK primary key (HOT_TUR_ANO, HOT_TUR_PERIODO, HOT_TUR_DIS_DISCIPLINA, HOT_TUR_TURMA, HOT_DIA_SEMANA, HOT_HORA_INICIO);
alter table HORARIOS_TURMA
  add constraint HOT_SAL_FK foreign key (HOT_SAL_COD_SALA)
  references SALAS (SAL_COD_SALA);
alter table HORARIOS_TURMA
  add constraint HOT_TUR_FK foreign key (HOT_TUR_ANO, HOT_TUR_PERIODO, HOT_TUR_DIS_DISCIPLINA, HOT_TUR_TURMA)
  references TURMAS (TUR_ANO, TUR_PERIODO, TUR_DIS_DISCIPLINA, TUR_TURMA);
alter table HORARIOS_TURMA
  add constraint HOT_DIA_SEMANA_CK
  check (Hot_Dia_Semana BETWEEN 1 AND 7);
alter table HORARIOS_TURMA
  add constraint HOT_PERIODO_CK
  check (HoT_Tur_Periodo between 0 and 2);

--Creating table INTERRUPCOES_MATRICULA
--=====================================
create table INTERRUPCOES_MATRICULA
(
  IMA_ALU_MATRICULA         CHARACTER VARYING(9) not null,
  IMA_SOI_TRA_NUM_TRANSACAO NUMERIC(9) not null,
  IMA_ANO                   NUMERIC(4) not null,
  IMA_PERIODO               NUMERIC(1) not null,
  IMA_TIPO_INTERRUP         NUMERIC(1) not null,
  IMA_DATA_HORA             DATE
);
comment on column INTERRUPCOES_MATRICULA.IMA_TIPO_INTERRUP
  is 'TOTAL=1;PARCIAL=2;INSTITUCIONAL=3';
alter table INTERRUPCOES_MATRICULA
  add constraint IMA_ALU_FK foreign key (IMA_ALU_MATRICULA)
  references ALUNOS (ALU_MATRICULA);
alter table INTERRUPCOES_MATRICULA
  add constraint IMA_PERIODO_CK
  check (Ima_Periodo    BETWEEN 1 AND 2);
alter table INTERRUPCOES_MATRICULA
  add constraint IMA_TIPO_INTERRUP_CK
  check (Ima_Tipo_Interrup  BETWEEN 1 AND 3);
create index IMA_INDX on INTERRUPCOES_MATRICULA (IMA_ALU_MATRICULA);
create index IMA_TIP_IDX on INTERRUPCOES_MATRICULA (IMA_TIPO_INTERRUP, IMA_PERIODO, IMA_ANO);

--Creating table MUNICIPIOS_BRASILEIROS
--=====================================
create table MUNICIPIOS_BRASILEIROS
(
  MUN_CODIGO              INTEGER not null,
  MUN_NOME                CHARACTER VARYING(100),
  MUN_NOME_SEM_FORMATACAO CHARACTER VARYING(100),
  MUN_UF                  CHAR(2),
  MUN_REGIAO              CHAR(2),
  MUN_LATITUDE            NUMERIC(7,5),
  MUN_LONGITUDE           NUMERIC(7,5)
);
alter table MUNICIPIOS_BRASILEIROS
  add constraint PK_MUNICIPIOS_BRASILEIROS primary key (MUN_CODIGO);

--Creating table NOTAS_MATRICULA
--==============================
create table NOTAS_MATRICULA
(
  NOM_SON_TRA_NUM_TRANSACAO  NUMERIC(9) not null,
  NOM_TIPO_NOTA              NUMERIC(2),
  NOM_VALOR_NOTA             NUMERIC(4,2),
  NOM_MAT_ALU_MATRICULA      CHARACTER VARYING(9) not null,
  NOM_MAT_TUR_DIS_DISCIPLINA NUMERIC(7) not null,
  NOM_MAT_TUR_ANO            NUMERIC(4) not null,
  NOM_MAT_TUR_PERIODO        NUMERIC(1) not null,
  NOM_AVT_TUR_TURMA          CHARACTER VARYING(2) not null,
  NOM_AVT_TUR_ANO            NUMERIC(4) not null,
  NOM_AVT_TUR_PERIODO        NUMERIC(1) not null,
  NOM_AVT_TUR_DIS_DISCIPLINA NUMERIC(7) not null,
  NOM_AVT_AVALIACAO          NUMERIC(2) not null
);
comment on column NOTAS_MATRICULA.NOM_SON_TRA_NUM_TRANSACAO
  is 'Transação de
solicitação do registro de notas';
comment on column NOTAS_MATRICULA.NOM_TIPO_NOTA
  is 'Indica o tipo de nota registrada:
1-Exercício
2-Prova final
3-Segunda época
5-Bimestre';
comment on column NOTAS_MATRICULA.NOM_VALOR_NOTA
  is 'Nota do aluno na avaliação/prova';
comment on column NOTAS_MATRICULA.NOM_AVT_AVALIACAO
  is 'Número da avaliação/prova';
alter table NOTAS_MATRICULA
  add constraint NOM_PK primary key (NOM_MAT_ALU_MATRICULA, NOM_MAT_TUR_DIS_DISCIPLINA, NOM_MAT_TUR_ANO, NOM_MAT_TUR_PERIODO, NOM_AVT_TUR_TURMA, NOM_AVT_TUR_ANO, NOM_AVT_TUR_PERIODO, NOM_AVT_TUR_DIS_DISCIPLINA, NOM_AVT_AVALIACAO);
alter table NOTAS_MATRICULA
  add constraint R_72 foreign key (NOM_MAT_ALU_MATRICULA, NOM_MAT_TUR_DIS_DISCIPLINA, NOM_MAT_TUR_ANO, NOM_MAT_TUR_PERIODO)
  references MATRICULAS (MAT_ALU_MATRICULA, MAT_TUR_DIS_DISCIPLINA, MAT_TUR_ANO, MAT_TUR_PERIODO);
alter table NOTAS_MATRICULA
  add constraint R_75 foreign key (NOM_AVT_TUR_TURMA, NOM_AVT_TUR_ANO, NOM_AVT_TUR_PERIODO, NOM_AVT_TUR_DIS_DISCIPLINA, NOM_AVT_AVALIACAO)
  references AVALIACOES_TURMA (AVT_TUR_TURMA, AVT_TUR_ANO, AVT_TUR_PERIODO, AVT_TUR_DIS_DISCIPLINA, AVT_AVALIACAO);
alter table NOTAS_MATRICULA
  add constraint MAT_TUR_PERIODO_CK18
  check (NOM_Mat_Tur_Periodo  BETWEEN 0 AND 2);
alter table NOTAS_MATRICULA
  add constraint NOM_TIPO_NOTA_CK
  check (NOM_TIPO_NOTA IN (1, 2, 3, 5));
alter table NOTAS_MATRICULA
  add constraint NOM_VALOR_NOTA_CK5
  check (Nom_Valor_Nota   >= 0.00);
alter table NOTAS_MATRICULA
  add constraint TUR_PERIODO_CK23
  check (NOM_AVT_Tur_Periodo BETWEEN 0 AND 2);
create index XIF1NOTAS_MATRICULA on NOTAS_MATRICULA (NOM_MAT_ALU_MATRICULA, NOM_MAT_TUR_DIS_DISCIPLINA, NOM_MAT_TUR_ANO, NOM_MAT_TUR_PERIODO);
create index XIF2NOTAS_MATRICULA on NOTAS_MATRICULA (NOM_AVT_TUR_TURMA, NOM_AVT_TUR_ANO, NOM_AVT_TUR_PERIODO, NOM_AVT_TUR_DIS_DISCIPLINA, NOM_AVT_AVALIACAO);

--Creating table NOTAS_BIMESTRE
--=============================
create table NOTAS_BIMESTRE
(
  NOB_NOM_MAT_ALU_MATRICULA      CHARACTER VARYING(9) not null,
  NOB_NOM_MAT_TUR_DIS_DISCIPLINA NUMERIC(7) not null,
  NOB_NOM_MAT_TUR_ANO            NUMERIC(4) not null,
  NOB_NOM_MAT_TUR_PERIODO        NUMERIC(1) not null,
  NOB_NOM_AVT_TUR_TURMA          CHARACTER VARYING(2) not null,
  NOB_NOM_AVT_TUR_ANO            NUMERIC(4) not null,
  NOB_NOM_AVT_TUR_PERIODO        NUMERIC(1) not null,
  NOB_NOM_AVT_TUR_DIS_DISCIPLINA NUMERIC(7) not null,
  NOB_NOM_AVT_AVALIACAO          NUMERIC(2) not null,
  NOB_VALOR_NOTA                 NUMERIC(4,2),
  NOB_TIPO_NOTA                  CHARACTER VARYING(1),
  NOB_AVB_NUMERO                 NUMERIC(4) not null
);
comment on table NOTAS_BIMESTRE
  is 'Armazena os valores de notas de exercícios e recuperação do aluno em cada bimestre. Contém a execução do que foi previsto em AVALIACOES_BIMESTRAIS';
comment on column NOTAS_BIMESTRE.NOB_VALOR_NOTA
  is 'Valor obtido como nota pelo aluno na avaliação';
comment on column NOTAS_BIMESTRE.NOB_TIPO_NOTA
  is 'Indica se a nota corresponde a um exercício ou recuperação';
alter table NOTAS_BIMESTRE
  add constraint XPKNOTAS_BIMESTRE primary key (NOB_NOM_MAT_ALU_MATRICULA, NOB_NOM_MAT_TUR_DIS_DISCIPLINA, NOB_NOM_MAT_TUR_ANO, NOB_NOM_MAT_TUR_PERIODO, NOB_NOM_AVT_TUR_TURMA, NOB_NOM_AVT_TUR_ANO, NOB_NOM_AVT_TUR_PERIODO, NOB_NOM_AVT_TUR_DIS_DISCIPLINA, NOB_NOM_AVT_AVALIACAO, NOB_AVB_NUMERO);
alter table NOTAS_BIMESTRE
  add constraint R_84 foreign key (NOB_NOM_MAT_ALU_MATRICULA, NOB_NOM_MAT_TUR_DIS_DISCIPLINA, NOB_NOM_MAT_TUR_ANO, NOB_NOM_MAT_TUR_PERIODO, NOB_NOM_AVT_TUR_TURMA, NOB_NOM_AVT_TUR_ANO, NOB_NOM_AVT_TUR_PERIODO, NOB_NOM_AVT_TUR_DIS_DISCIPLINA, NOB_NOM_AVT_AVALIACAO)
  references NOTAS_MATRICULA (NOM_MAT_ALU_MATRICULA, NOM_MAT_TUR_DIS_DISCIPLINA, NOM_MAT_TUR_ANO, NOM_MAT_TUR_PERIODO, NOM_AVT_TUR_TURMA, NOM_AVT_TUR_ANO, NOM_AVT_TUR_PERIODO, NOM_AVT_TUR_DIS_DISCIPLINA, NOM_AVT_AVALIACAO);
alter table NOTAS_BIMESTRE
  add constraint MAT_TUR_PERIODO_CK84
  check (NOB_NOM_MAT_TUR_PERIODO  BETWEEN 0 AND 2);
alter table NOTAS_BIMESTRE
  add constraint TIPO_AVALIAÇÃO
  check (NOB_TIPO_NOTA IN (1, 2));
alter table NOTAS_BIMESTRE
  add constraint TUR_PERIODO_CK108
  check (NOB_NOM_AVT_TUR_PERIODO BETWEEN 0 AND 2);

--Creating table OFERTA_DE_VAGAS
--==============================
create table OFERTA_DE_VAGAS
(
  OV_CODCURSO             NUMERIC(8) not null,
  OV_NIVEL                CHAR(1),
  OV_TIPO_PROC_SELETIVO   CHAR(3),
  OV_ANO                  NUMERIC(4),
  OV_PERIODO              NUMERIC(1),
  OV_NUM_VAGAS            NUMERIC,
  OV_TIPO_ACAO_AFIRMATIVA CHAR(10),
  OV_CODCOPERVE           NUMERIC(5),
  OV_POLO_EAD             NUMERIC(2)
);
comment on column OFERTA_DE_VAGAS.OV_CODCURSO
  is 'SE GRADUAÇAO PEGA COD SCA, SE PÓS, PEGA COD CAPES';
comment on column OFERTA_DE_VAGAS.OV_NIVEL
  is 'G-GRADUACAO, P-POS-GRADUACAO, D-EAD';
comment on column OFERTA_DE_VAGAS.OV_TIPO_PROC_SELETIVO
  is 'AS-PSS; PA-PROCESSO SELETIVO ALTERNATIVO; VE-VESTIBULAR; VM-VESTIBULAR+ENEM';
comment on column OFERTA_DE_VAGAS.OV_TIPO_ACAO_AFIRMATIVA
  is 'RPR-RACIAL-PRETO; RPA-RACIAL-PARDO; RIN-RACIAL-INDIO; RRQ-RACIAL-REMANECENTE QUILOMBO; SPN-SOCIAL NEC.ESPECIAIS; SRP-SOCIAL REDE PUBLICA;SFUFPB-SOCIAL FUNC.UFPB; SFOF-SOCIAL FUNC.ORGAOS FEDERAIS;SPRP-SOCIAL PROF. REDE PUBLICA';
comment on column OFERTA_DE_VAGAS.OV_POLO_EAD
  is 'POLOS DE ACORDO COM A TABELA ''AREAS_ESPEC_CURRICULOS''';

--Creating table ORIGEM_VAGA
--==========================
create table ORIGEM_VAGA
(
  ALU_MATRICULA CHARACTER VARYING(9),
  ORIGEM_VAGA   CHARACTER VARYING(2)
);
comment on column ORIGEM_VAGA.ORIGEM_VAGA
  is '01 - DEMANDA SOCIAL ; 02 - PROFESSOR';

--Creating table PAISES
--=====================
create table PAISES
(
  PAI_CODIGO_ISO CHAR(3) not null,
  PAI_NOME       CHARACTER VARYING(100)
);
alter table PAISES
  add constraint PK_PAISES primary key (PAI_CODIGO_ISO);

--Creating table PARAMETROS_CENTRO
--================================
create table PARAMETROS_CENTRO
(
  PCN_CEN_COD_CENTRO             CHARACTER VARYING(8) not null,
  PCN_ANO_TRANSACIONAL           NUMERIC(4),
  PCN_PERIODO_TRANSACIONAL       NUMERIC(4),
  PCN_MATRICULA_ATIVA            CHARACTER VARYING(1),
  PCN_REG_NOTAS_ATIVA            CHARACTER VARYING(1),
  PCN_INTER_TOT_ATIVA            CHARACTER VARYING(1),
  PCN_INTER_PAR_ATIVA            CHARACTER VARYING(1),
  PCN_CANCEL_ATIVA               CHARACTER VARYING(1),
  PCN_OFERTA_ATIVA               CHARACTER VARYING(1),
  PCN_ANO_OFERTA                 NUMERIC(4),
  PCN_PERIODO_OFERTA             NUMERIC(4),
  PCN_DIARIO_ATIVO               CHARACTER VARYING(1),
  PCN_MATRICULA_WEB_ATIVA        CHARACTER VARYING(1),
  PCN_MATRICULA_WEB_VAL_SEMESTRE CHARACTER VARYING(1),
  PCN_NOTAS_WEB_ATIVA            CHARACTER VARYING(1),
  PCN_NOTAS_WEB_ONLY             CHARACTER VARYING(1),
  PCN_TIPO_HORARIO_TURMA         CHARACTER VARYING(1),
  PCN_ANO_REG_NOTAS              NUMERIC(4),
  PCN_PERIODO_REG_NOTAS          NUMERIC(4),
  PCN_ANO_AVALIA_DOCENTE         NUMERIC(4),
  PCN_PERIODO_AVALIA_DOCENTE     NUMERIC(4),
  PCN_AVALIA_DOCENTE_ATIVA       CHARACTER VARYING(1) default 'N',
  PCN_AVALIA_DOCENTE_OBRIGATORIA CHARACTER VARYING(1) default 'N'
);
comment on column PARAMETROS_CENTRO.PCN_CEN_COD_CENTRO
  is 'Identificador do Centro';
comment on column PARAMETROS_CENTRO.PCN_ANO_TRANSACIONAL
  is 'Ano padrão (período
letivo) para as transações do Centro';
comment on column PARAMETROS_CENTRO.PCN_PERIODO_TRANSACIONAL
  is 'Período padrão
(período letivo) para as transações do Centro';
comment on column PARAMETROS_CENTRO.PCN_MATRICULA_ATIVA
  is 'Indica se as transações
de matrícula estão ativas (disponíveis) para uso pelo Centro.';
comment on column PARAMETROS_CENTRO.PCN_REG_NOTAS_ATIVA
  is 'Indica se as transações
de registro de notas estão ativas (disponíveis) para uso pelo Centro.';
comment on column PARAMETROS_CENTRO.PCN_INTER_TOT_ATIVA
  is 'Indica se as transações
de trancamento total estão ativas (disponíveis) para uso pelo Centro.';
comment on column PARAMETROS_CENTRO.PCN_INTER_PAR_ATIVA
  is 'Indica se as transações
de trancamento parcial estão ativas (disponíveis) para uso pelo Centro.';
comment on column PARAMETROS_CENTRO.PCN_CANCEL_ATIVA
  is 'Indica se as transações de
cancelamento de matrícula estão ativas (disponíveis) para uso pelo Centro.';
comment on column PARAMETROS_CENTRO.PCN_OFERTA_ATIVA
  is 'Indica se as transações de
oferta de turmas estão ativas (disponíveis) para uso pelo Centro.';
comment on column PARAMETROS_CENTRO.PCN_ANO_OFERTA
  is 'Indica o ano do período
letivo para fins da oferta do Centro.';
comment on column PARAMETROS_CENTRO.PCN_PERIODO_OFERTA
  is 'Indica o período do
período letivo para fins da oferta do Centro.';
comment on column PARAMETROS_CENTRO.PCN_DIARIO_ATIVO
  is 'Indica se as transações de
emissão de diário de classe estão ativas (disponíveis) para uso pelo Centro.';
comment on column PARAMETROS_CENTRO.PCN_MATRICULA_WEB_ATIVA
  is 'Indica se as
transações de matrícula via Internet estão ativas (disponíveis) para uso pelo
Centro.';
comment on column PARAMETROS_CENTRO.PCN_MATRICULA_WEB_VAL_SEMESTRE
  is 'Indica se nas
transações de matrícula via Internet, o sistema deve validar o semestre ideal da
disciplina para o aluno (blocagem).';
comment on column PARAMETROS_CENTRO.PCN_NOTAS_WEB_ATIVA
  is 'Indica se as transações
de registro de notas via Internet estão ativas (disponíveis) para uso pelo Centro.';
comment on column PARAMETROS_CENTRO.PCN_NOTAS_WEB_ONLY
  is 'Indica se as transações
de registro de notas estão ativas (disponíveis) para uso pelo Centro exclusivamente
via Internet.';
comment on column PARAMETROS_CENTRO.PCN_TIPO_HORARIO_TURMA
  is 'Indica o tipo de horário permitido para as turmas do Centro:
P - Padrão UFPB
L - Livre (sem validação)
M - Modular
1 - Aula de 45 minutos';
comment on column PARAMETROS_CENTRO.PCN_ANO_REG_NOTAS
  is 'Ano letivo específico para as transações de registro de notas';
comment on column PARAMETROS_CENTRO.PCN_PERIODO_REG_NOTAS
  is 'Período letivo específico para as transações de registro de notas';
comment on column PARAMETROS_CENTRO.PCN_ANO_AVALIA_DOCENTE
  is 'Referente ao ano da avaliação dos docentes pelos discentes';
comment on column PARAMETROS_CENTRO.PCN_PERIODO_AVALIA_DOCENTE
  is 'Referente ao periodo da avaliação dos docentes pelos discentes';
comment on column PARAMETROS_CENTRO.PCN_AVALIA_DOCENTE_ATIVA
  is 'Indica se avaliação dos docentes pelos discentes está ativa ou não';
comment on column PARAMETROS_CENTRO.PCN_AVALIA_DOCENTE_OBRIGATORIA
  is 'Indica se avaliação dos docentes pelos discentes é obrigatória ou não';
alter table PARAMETROS_CENTRO
  add constraint XPKPARAMETROS_CENTRO primary key (PCN_CEN_COD_CENTRO);
alter table PARAMETROS_CENTRO
  add constraint XFKPARAMETROS_CENTRO foreign key (PCN_CEN_COD_CENTRO)
  references CENTROS (CEN_COD_CENTRO);
alter table PARAMETROS_CENTRO
  add constraint SIM_NÃO10
  check (PCN_MATRICULA_WEB_VAL_SEMESTRE IN
('S', 'N'));
alter table PARAMETROS_CENTRO
  add constraint SIM_NÃO11
  check (PCN_NOTAS_WEB_ATIVA IN ('S', 'N'));
alter table PARAMETROS_CENTRO
  add constraint SIM_NÃO12
  check (PCN_NOTAS_WEB_ONLY IN ('S', 'N'));
alter table PARAMETROS_CENTRO
  add constraint SIM_NÃO2
  check (PCN_MATRICULA_ATIVA IN ('S', 'N'));
alter table PARAMETROS_CENTRO
  add constraint SIM_NÃO3
  check (PCN_REG_NOTAS_ATIVA IN ('S', 'N'));
alter table PARAMETROS_CENTRO
  add constraint SIM_NÃO323
  check (PCN_AVALIA_DOCENTE_ATIVA IN ('S', 'N'));
alter table PARAMETROS_CENTRO
  add constraint SIM_NÃO324
  check (PCN_AVALIA_DOCENTE_OBRIGATORIA IN ('S', 'N'));
alter table PARAMETROS_CENTRO
  add constraint SIM_NÃO4
  check (PCN_INTER_TOT_ATIVA IN ('S', 'N'));
alter table PARAMETROS_CENTRO
  add constraint SIM_NÃO5
  check (PCN_INTER_PAR_ATIVA IN ('S', 'N'));
alter table PARAMETROS_CENTRO
  add constraint SIM_NÃO6
  check (PCN_CANCEL_ATIVA IN ('S', 'N'));
alter table PARAMETROS_CENTRO
  add constraint SIM_NÃO7
  check (PCN_OFERTA_ATIVA IN ('S', 'N'));
alter table PARAMETROS_CENTRO
  add constraint SIM_NÃO8
  check (PCN_DIARIO_ATIVO IN ('S', 'N'));
alter table PARAMETROS_CENTRO
  add constraint SIM_NÃO9
  check (PCN_MATRICULA_WEB_ATIVA IN ('S',
'N'));
alter table PARAMETROS_CENTRO
  add constraint TIPO_HORARIO_TURMA
  check (PCN_TIPO_HORARIO_TURMA IN ('P', 'L', 'M', '1'));

--Creating table PARTICIPACOES_AULA
--=================================
create table PARTICIPACOES_AULA
(
  PTA_MAT_ALU_MATRICULA      CHARACTER VARYING(9) not null,
  PTA_MAT_TUR_DIS_DISCIPLINA NUMERIC(7) not null,
  PTA_MAT_TUR_ANO            NUMERIC(4) not null,
  PTA_MAT_TUR_PERIODO        NUMERIC(1) not null,
  PTA_AUT_TUR_ANO            NUMERIC(4) not null,
  PTA_AUT_TUR_PERIODO        NUMERIC(1) not null,
  PTA_AUT_TUR_DIS_DISCIPLINA NUMERIC(7) not null,
  PTA_AUT_TUR_TURMA          CHARACTER VARYING(2) not null,
  PTA_AUT_AULA               NUMERIC(3) not null,
  PTA_COMENTARIOS            CHARACTER VARYING(256),
  PTA_CONFIRMA_AULA          CHARACTER VARYING(1),
  PTA_DATA_HORA_REGISTRO     DATE
);
comment on table PARTICIPACOES_AULA
  is 'Contém registros espontâneos dos alunos
sobre a aula ministrada';
comment on column PARTICIPACOES_AULA.PTA_AUT_AULA
  is 'Número identificador da aula
no curso/turma';
comment on column PARTICIPACOES_AULA.PTA_COMENTARIOS
  is 'Comentários livres do aluno
sobre a aula ministrada';
comment on column PARTICIPACOES_AULA.PTA_CONFIRMA_AULA
  is 'Indica se o aluno
confirma a aula ou não (S/N)';
comment on column PARTICIPACOES_AULA.PTA_DATA_HORA_REGISTRO
  is 'Indica a data e hora
em que a participação do aluno foi registrada';
alter table PARTICIPACOES_AULA
  add constraint XPKPARTICIPACOES_AULA primary key (PTA_AUT_TUR_TURMA, PTA_AUT_TUR_DIS_DISCIPLINA, PTA_AUT_TUR_ANO, PTA_AUT_TUR_PERIODO, PTA_AUT_AULA, PTA_MAT_ALU_MATRICULA, PTA_MAT_TUR_DIS_DISCIPLINA, PTA_MAT_TUR_ANO, PTA_MAT_TUR_PERIODO);
alter table PARTICIPACOES_AULA
  add constraint R_68 foreign key (PTA_MAT_ALU_MATRICULA, PTA_MAT_TUR_DIS_DISCIPLINA, PTA_MAT_TUR_ANO, PTA_MAT_TUR_PERIODO)
  references MATRICULAS (MAT_ALU_MATRICULA, MAT_TUR_DIS_DISCIPLINA, MAT_TUR_ANO, MAT_TUR_PERIODO);
alter table PARTICIPACOES_AULA
  add constraint R_70 foreign key (PTA_AUT_TUR_ANO, PTA_AUT_TUR_PERIODO, PTA_AUT_TUR_DIS_DISCIPLINA, PTA_AUT_TUR_TURMA, PTA_AUT_AULA)
  references AULAS_TURMA (AUT_TUR_ANO, AUT_TUR_PERIODO, AUT_TUR_DIS_DISCIPLINA, AUT_TUR_TURMA, AUT_AULA);
alter table PARTICIPACOES_AULA
  add constraint MAT_TUR_PERIODO_CK7
  check (PTA_MAT_TUR_PERIODO  BETWEEN 0 AND 2);
alter table PARTICIPACOES_AULA
  add constraint SIM_NAO24
  check (PTA_CONFIRMA_AULA IN ('S', 'N'));
alter table PARTICIPACOES_AULA
  add constraint TUR_PERIODO_CK9
  check (PTA_AUT_TUR_PERIODO BETWEEN 0 AND 2);
create index XIF1PARTICIPACOES_AULA on PARTICIPACOES_AULA (PTA_MAT_ALU_MATRICULA, PTA_MAT_TUR_DIS_DISCIPLINA, PTA_MAT_TUR_ANO, PTA_MAT_TUR_PERIODO);
create index XIF2PARTICIPACOES_AULA on PARTICIPACOES_AULA (PTA_AUT_TUR_ANO, PTA_AUT_TUR_PERIODO, PTA_AUT_TUR_DIS_DISCIPLINA, PTA_AUT_TUR_TURMA, PTA_AUT_AULA);

--Creating table PEDIDOS_DISPENSA
--===============================
create table PEDIDOS_DISPENSA
(
  PED_CODIGO                 NUMERIC(6) not null,
  PED_ALU_MATRICULA          CHARACTER VARYING(9),
  PED_DIS_DISCIPLINA         NUMERIC(7),
  PED_TIPO_CR_CH             CHARACTER VARYING(1),
  PED_CR                     NUMERIC(3),
  PED_CH                     NUMERIC(3),
  PED_ANO                    NUMERIC(4),
  PED_PERIODO                NUMERIC(1),
  PED_LDS_COD_LOCAL_DISPENSA NUMERIC(4),
  PED_MEDIA_FINAL            NUMERIC(5,2),
  PED_ALU_MATRICULA_DESTINO  CHARACTER VARYING(9),
  PED_MENSAGEM_TRANSACAO     CHARACTER VARYING(60),
  PED_DATA_HORA              DATE,
  PED_OPERADOR               CHARACTER VARYING(10)
);
comment on table PEDIDOS_DISPENSA
  is 'Registros de solicitação de dispensa de
disciplinas, gerados pelo módulo setorial/escolaridade.';
comment on column PEDIDOS_DISPENSA.PED_CODIGO
  is 'Identificador do pedido de
dispensa (gerado pelo sistema)';
comment on column PEDIDOS_DISPENSA.PED_ALU_MATRICULA
  is 'Matrícula do aluno';
comment on column PEDIDOS_DISPENSA.PED_DIS_DISCIPLINA
  is 'Disciplina a dispensar (já
cursada pelo aluno em outra ocasião)';
comment on column PEDIDOS_DISPENSA.PED_TIPO_CR_CH
  is 'Indica se o sistema deve obter
créditos e carga horária da disciplina ou se é específico';
comment on column PEDIDOS_DISPENSA.PED_CR
  is 'Quantidade de créditos cursados na
disciplina';
comment on column PEDIDOS_DISPENSA.PED_CH
  is 'Quantidade de carga horária cursada na
disciplina';
comment on column PEDIDOS_DISPENSA.PED_ANO
  is 'Ano letivo no qual será registrado o
cumprimento da disciplina';
comment on column PEDIDOS_DISPENSA.PED_PERIODO
  is 'Período letivo no qual será
registrado o cumprimento da disciplina';
comment on column PEDIDOS_DISPENSA.PED_LDS_COD_LOCAL_DISPENSA
  is 'Local de dispensa
(origem da disciplina)';
comment on column PEDIDOS_DISPENSA.PED_MEDIA_FINAL
  is 'Média final do aluno, obtida
no curso original da disciplina';
comment on column PEDIDOS_DISPENSA.PED_ALU_MATRICULA_DESTINO
  is 'Matrícula de
destino (dispensa em grupo)';
comment on column PEDIDOS_DISPENSA.PED_MENSAGEM_TRANSACAO
  is 'Contém a mensagem de
processamento (se foi aceito ou negado o pedido de dispensa)';
comment on column PEDIDOS_DISPENSA.PED_DATA_HORA
  is 'Data e hora do registro de
dispensa';
comment on column PEDIDOS_DISPENSA.PED_OPERADOR
  is 'Operador do sistema no momento
do pedido de dispensa';
alter table PEDIDOS_DISPENSA
  add constraint XPKPEDIDOS_DISPENSA primary key (PED_CODIGO);
alter table PEDIDOS_DISPENSA
  add constraint TIPO_CR_CH
  check (PED_TIPO_CR_CH IN ('D', 'E'));

--Creating table TIPOS_PRE_REQUISITO
--==================================
create table TIPOS_PRE_REQUISITO
(
  TPR_COD_TIPO  NUMERIC(1) not null,
  TPR_DESCRICAO CHARACTER VARYING(30)
);
alter table TIPOS_PRE_REQUISITO
  add constraint TPR_PK primary key (TPR_COD_TIPO);

--Creating table PRE_REQUISITOS_DISCIPLINA
--========================================
create table PRE_REQUISITOS_DISCIPLINA
(
  PRD_DIC_CCU_CUR_COD_CURSO NUMERIC(8) not null,
  PRD_DIC_CCU_COD_CURRICULO NUMERIC(5) not null,
  PRD_DIC_DIS_DISCIPLINA    NUMERIC(7) not null,
  PRD_TPR_COD_TIPO          NUMERIC(1) not null,
  PRD_CONDICAO              NUMERIC(7) not null,
  PRD_OPERADOR              CHAR(2),
  PRD_ORDEM_PRIOR           NUMERIC(2) not null
);
alter table PRE_REQUISITOS_DISCIPLINA
  add constraint PRD_DIC_FK foreign key (PRD_DIC_CCU_CUR_COD_CURSO, PRD_DIC_CCU_COD_CURRICULO, PRD_DIC_DIS_DISCIPLINA)
  references DISCIPLINAS_CURRICULO (DIC_CCU_CUR_COD_CURSO, DIC_CCU_COD_CURRICULO, DIC_DIS_DISCIPLINA);
alter table PRE_REQUISITOS_DISCIPLINA
  add constraint PRD_TPR_FK foreign key (PRD_TPR_COD_TIPO)
  references TIPOS_PRE_REQUISITO (TPR_COD_TIPO);
alter table PRE_REQUISITOS_DISCIPLINA
  add constraint PRD_OPERADOR_CK
  check (PrD_Operador IN ('E', 'OU',''));
alter table PRE_REQUISITOS_DISCIPLINA
  add constraint PRD_TPR_COD_TIPO_CK
  check (PrD_TpR_Cod_Tipo BETWEEN 1 AND 5);
create index PRD_INDX on PRE_REQUISITOS_DISCIPLINA (PRD_DIC_CCU_CUR_COD_CURSO, PRD_DIC_CCU_COD_CURRICULO, PRD_DIC_DIS_DISCIPLINA);

--Creating table PROFESSORES
--==========================
create table PROFESSORES
(
  PRO_MATR_DOCENTE     NUMERIC(9) not null,
  PRO_SET_COD_SETOR    CHARACTER VARYING(8) not null,
  PRO_NOME             CHARACTER VARYING(60),
  PRO_TITULACAO        CHARACTER VARYING(30),
  PRO_ENDERECO         CHARACTER VARYING(150),
  PRO_MATR_DOCENTE_SRH NUMERIC(8),
  PRO_SENHA            CHARACTER VARYING(8),
  PRO_DICA_SENHA       CHARACTER VARYING(40),
  PRO_EMAIL            CHARACTER VARYING(50)
);
alter table PROFESSORES
  add constraint PRO_PK2 primary key (PRO_MATR_DOCENTE);
create index PRO_NOME_INDX2 on PROFESSORES (PRO_NOME);

--Creating table PROFESSORES_TURMA
--================================
create table PROFESSORES_TURMA
(
  PTU_TUR_TURMA          CHARACTER VARYING(2) not null,
  PTU_TUR_DIS_DISCIPLINA NUMERIC(7) not null,
  PTU_TUR_ANO            NUMERIC(4) not null,
  PTU_TUR_PERIODO        NUMERIC(1) not null,
  PTU_PRO_MATR_DOCENTE   NUMERIC(9) not null,
  PTU_CH_ESPECIFICA      NUMERIC(6,2)
);
alter table PROFESSORES_TURMA
  add constraint PTU_PK primary key (PTU_TUR_ANO, PTU_TUR_PERIODO, PTU_TUR_DIS_DISCIPLINA, PTU_TUR_TURMA, PTU_PRO_MATR_DOCENTE);
alter table PROFESSORES_TURMA
  add constraint PTU_PRO_FK foreign key (PTU_PRO_MATR_DOCENTE)
  references PROFESSORES (PRO_MATR_DOCENTE);
alter table PROFESSORES_TURMA
  add constraint PTU_TUR_FK foreign key (PTU_TUR_ANO, PTU_TUR_PERIODO, PTU_TUR_DIS_DISCIPLINA, PTU_TUR_TURMA)
  references TURMAS (TUR_ANO, TUR_PERIODO, TUR_DIS_DISCIPLINA, TUR_TURMA);
alter table PROFESSORES_TURMA
  add constraint PTU_TUR_PERIODO_CK
  check (Ptu_tur_periodo between 0 and 2);

--Creating table SERVIDOR_LOG
--===========================
create table SERVIDOR_LOG
(
  SEL_DATA_HORA DATE,
  SEL_OPERADOR  CHARACTER VARYING(20),
  SEL_PROGRAMA  CHARACTER VARYING(32),
  SEL_SQL_CODE  CHARACTER VARYING(16),
  SEL_NUM_TRANS CHARACTER VARYING(9),
  SEL_TIPO_LOG  NUMERIC(1)
);
create index SEL_DAT_HOR_IDX on SERVIDOR_LOG (SEL_DATA_HORA);

--Creating table SOLICITACOES_CADERNETA
--=====================================
create table SOLICITACOES_CADERNETA
(
  SCD_TRA_NUM_TRANSACAO NUMERIC(9) not null,
  SCD_TIPO_ACAO         CHARACTER VARYING(100),
  SCD_TIPO_DADO         CHARACTER VARYING(100),
  SCD_TURMA             CHARACTER VARYING(2),
  SCD_DISCIPLINA        NUMERIC(7),
  SCD_ANO               NUMERIC(4),
  SCD_PERIODO           NUMERIC(1),
  SCD_COD_STATUS        CHAR(2),
  SCD_COD_MOTIVO        CHAR(2),
  SCD_DETALHES          CHARACTER VARYING(1000)
);
comment on table SOLICITACOES_CADERNETA
  is 'Logs de solicitacoes da caderneta online';
alter table SOLICITACOES_CADERNETA
  add constraint SCD_PK primary key (SCD_TRA_NUM_TRANSACAO);
alter table SOLICITACOES_CADERNETA
  add constraint SCD_FK foreign key (SCD_TRA_NUM_TRANSACAO)
  references TRANSACOES (TRA_NUM_TRANSACAO);
alter table SOLICITACOES_CADERNETA
  add constraint SCD_COD_MOTIVO_CK
  check (SCD_Cod_Motivo BETWEEN '00' AND '99');
alter table SOLICITACOES_CADERNETA
  add constraint SCD_COD_STATUS_CK
  check (SCD_Cod_Status BETWEEN '00' AND '99');

--Creating table SOLICITACOES_CANCELAMENTO
--========================================
create table SOLICITACOES_CANCELAMENTO
(
  SOC_TRA_NUM_TRANSACAO NUMERIC(9) not null,
  SOC_MATRICULA         CHARACTER VARYING(9),
  SOC_TURMA             CHARACTER VARYING(2),
  SOC_DISCIPLINA        NUMERIC(7),
  SOC_ANO               NUMERIC(4),
  SOC_PERIODO           NUMERIC(1),
  SOC_COD_STATUS        CHAR(2),
  SOC_COD_MOTIVO        CHAR(2)
);
comment on table SOLICITACOES_CANCELAMENTO
  is 'Logs de solicitacoes para cancelamento de matrícula';
alter table SOLICITACOES_CANCELAMENTO
  add constraint SOC_PK primary key (SOC_TRA_NUM_TRANSACAO);
alter table SOLICITACOES_CANCELAMENTO
  add constraint SOC_TRA_FK foreign key (SOC_TRA_NUM_TRANSACAO)
  references TRANSACOES (TRA_NUM_TRANSACAO);
alter table SOLICITACOES_CANCELAMENTO
  add constraint SOC_COD_MOTIVO_CK
  check (Soc_Cod_Motivo BETWEEN '00' AND '99');
alter table SOLICITACOES_CANCELAMENTO
  add constraint SOC_COD_STATUS_CK
  check (Soc_Cod_Status BETWEEN '00' AND '99');

--Creating table SOLICITACOES_HISTORICO
--=====================================
create table SOLICITACOES_HISTORICO
(
  SOH_TRA_NUM_TRANSACAO NUMERIC(9) not null,
  SOH_MATRICULA         CHARACTER VARYING(9),
  SOH_CONFIRMADO        CHAR(1)
);
alter table SOLICITACOES_HISTORICO
  add constraint SOH_PK primary key (SOH_TRA_NUM_TRANSACAO);
alter table SOLICITACOES_HISTORICO
  add constraint SOH_TRA_FK foreign key (SOH_TRA_NUM_TRANSACAO)
  references TRANSACOES (TRA_NUM_TRANSACAO);
alter table SOLICITACOES_HISTORICO
  add constraint SOH_CONFIRMADO_CK
  check (SoH_Confirmado IN ('S', 'N'));
create index SOH_MAT_CONF on SOLICITACOES_HISTORICO (SOH_MATRICULA, SOH_CONFIRMADO);

--Creating table SOLICITACOES_INTERRUPCAO
--=======================================
create table SOLICITACOES_INTERRUPCAO
(
  SOI_TRA_NUM_TRANSACAO NUMERIC(9) not null,
  SOI_MATRICULA         CHARACTER VARYING(9),
  SOI_ANO               NUMERIC(4),
  SOI_PERIODO           NUMERIC(1),
  SOI_TIPO_INTERRUP     NUMERIC(1),
  SOI_COD_STATUS        CHAR(2) not null,
  SOI_COD_MOTIVO        CHAR(2)
);
alter table SOLICITACOES_INTERRUPCAO
  add constraint SOI_PK primary key (SOI_TRA_NUM_TRANSACAO);
alter table SOLICITACOES_INTERRUPCAO
  add constraint SOI_TRA_FK foreign key (SOI_TRA_NUM_TRANSACAO)
  references TRANSACOES (TRA_NUM_TRANSACAO);
alter table SOLICITACOES_INTERRUPCAO
  add constraint SOI_COD_MOTIVO_CK
  check (SoI_Cod_Motivo BETWEEN '00' AND '99');
alter table SOLICITACOES_INTERRUPCAO
  add constraint SOI_COD_STATUS_CK
  check (SoI_Cod_Status BETWEEN '00' AND '99');
alter table SOLICITACOES_INTERRUPCAO
  add constraint SOI_TIPO_INTERRUP_CK
  check (SoI_Tipo_Interrup BETWEEN 1 AND 3);

--Creating table SOLICITACOES_MATRICULA
--=====================================
create table SOLICITACOES_MATRICULA
(
  SOM_TRA_NUM_TRANSACAO NUMERIC(9) not null,
  SOM_MATRICULA         CHARACTER VARYING(9),
  SOM_TURMA             CHARACTER VARYING(2),
  SOM_DISCIPLINA        NUMERIC(7),
  SOM_ANO               NUMERIC(4),
  SOM_PERIODO           NUMERIC(1),
  SOM_CURSO_EXTRA       NUMERIC(8),
  SOM_CURRICULO_EXTRA   NUMERIC(5),
  SOM_COD_STATUS        CHAR(2),
  SOM_COD_MOTIVO        CHAR(2)
);
alter table SOLICITACOES_MATRICULA
  add constraint SOM_TRA_FK foreign key (SOM_TRA_NUM_TRANSACAO)
  references TRANSACOES (TRA_NUM_TRANSACAO);
alter table SOLICITACOES_MATRICULA
  add constraint SOM_COD_MOTIVO_CK
  check (Som_Cod_Motivo   BETWEEN '00' AND '99');
alter table SOLICITACOES_MATRICULA
  add constraint SOM_COD_STATUS_CK
  check (Som_Cod_Status   BETWEEN '00' AND '99');
create index SOM_ANO_PER on SOLICITACOES_MATRICULA (SOM_ANO, SOM_PERIODO);
create index SOM_IDX on SOLICITACOES_MATRICULA (SOM_MATRICULA, SOM_TURMA, SOM_DISCIPLINA, SOM_ANO, SOM_PERIODO);
create index SOM_TRA_IDX on SOLICITACOES_MATRICULA (SOM_TRA_NUM_TRANSACAO);
create index SOM_TRA_TUR_DISC on SOLICITACOES_MATRICULA (SOM_TRA_NUM_TRANSACAO, SOM_TURMA, SOM_DISCIPLINA);

--Creating table SOLICITACOES_OFERTA
--==================================
create table SOLICITACOES_OFERTA
(
  SOF_TRA_NUM_TRANSACAO NUMERIC(9) not null,
  SOF_COD_CURSO         NUMERIC(8),
  SOF_ANO               NUMERIC(4),
  SOF_PERIODO           NUMERIC(1),
  SOF_COD_DISCIPLINA    NUMERIC(7),
  SOF_HORARIOS          CHARACTER VARYING(45),
  SOF_VAGAS             NUMERIC(3),
  SOF_ANALISADO_DEPTO   CHAR(1) not null,
  SOF_COD_STATUS        CHAR(2),
  SOF_COD_MOTIVO        CHAR(2),
  SOF_OBSERVACOES       CHARACTER VARYING(80)
);
alter table SOLICITACOES_OFERTA
  add constraint SOF_TRA_FK foreign key (SOF_TRA_NUM_TRANSACAO)
  references TRANSACOES (TRA_NUM_TRANSACAO);
alter table SOLICITACOES_OFERTA
  add constraint SOF_ANALISADO_DEPTO_CK
  check (Sof_Analisado_Depto   IN ('S','N'));
alter table SOLICITACOES_OFERTA
  add constraint SOF_COD_MOTIVO_CK
  check (Sof_Cod_Motivo   BETWEEN '00' AND '99');
alter table SOLICITACOES_OFERTA
  add constraint SOF_COD_STATUS_CK
  check (Sof_Cod_Status   BETWEEN '00' AND '99');

--Creating table SOLICITACOES_REG_NOTA
--====================================
create table SOLICITACOES_REG_NOTA
(
  SON_TRA_NUM_TRANSACAO NUMERIC(9) not null,
  SON_MATRICULA         CHARACTER VARYING(9),
  SON_TURMA             CHARACTER VARYING(2),
  SON_DISCIPLINA        NUMERIC(7),
  SON_ANO               NUMERIC(4),
  SON_PERIODO           NUMERIC(1),
  SON_NUM_NOTA          NUMERIC(2),
  SON_VALOR_NOTA        NUMERIC(5,2),
  SON_COD_STATUS        CHAR(2),
  SON_COD_MOTIVO        CHAR(2)
);
alter table SOLICITACOES_REG_NOTA
  add constraint SON_PK primary key (SON_TRA_NUM_TRANSACAO);
alter table SOLICITACOES_REG_NOTA
  add constraint SON_TRA_FK foreign key (SON_TRA_NUM_TRANSACAO)
  references TRANSACOES (TRA_NUM_TRANSACAO);
alter table SOLICITACOES_REG_NOTA
  add constraint SON_COD_MOTIVO_CK
  check (SoN_Cod_Motivo   BETWEEN '00' AND '99');
alter table SOLICITACOES_REG_NOTA
  add constraint SON_COD_STATUS_CK
  check (SoN_Cod_STATUS   BETWEEN '00' AND '99');

--Creating table SOLICITACOES_RELACOES
--====================================
create table SOLICITACOES_RELACOES
(
  SOR_TRA_NUM_TRANSACAO NUMERIC(9) not null,
  SOR_MATRICULA         CHARACTER VARYING(9),
  SOR_ANO               NUMERIC(4),
  SOR_PERIODO           NUMERIC(1),
  SOR_COD_STATUS        CHAR(2),
  SOR_COD_MOTIVO        CHAR(2)
);
alter table SOLICITACOES_RELACOES
  add constraint SOR_PK primary key (SOR_TRA_NUM_TRANSACAO);
alter table SOLICITACOES_RELACOES
  add constraint SOR_TRA_FK foreign key (SOR_TRA_NUM_TRANSACAO)
  references TRANSACOES (TRA_NUM_TRANSACAO);

--Creating table VAGAS_OFERTADAS_SELECAO
--======================================
create table VAGAS_OFERTADAS_SELECAO
(
  VGO_PRS_CODIGO    NUMERIC(8) not null,
  VGO_CUR_COD_CURSO NUMERIC(8) not null,
  VGO_VAGAS         NUMERIC(4),
  VGO_VAGAS_TURNO   NUMERIC(4)
);
comment on column VAGAS_OFERTADAS_SELECAO.VGO_VAGAS
  is 'Vagas para reopção de Curso';
comment on column VAGAS_OFERTADAS_SELECAO.VGO_VAGAS_TURNO
  is 'Vagas para reopção Apenas de Turno';
alter table VAGAS_OFERTADAS_SELECAO
  add constraint VGO_PK primary key (VGO_PRS_CODIGO, VGO_CUR_COD_CURSO);
alter table VAGAS_OFERTADAS_SELECAO
  add constraint VGO_PRS_FK foreign key (VGO_PRS_CODIGO)
  references PROCESSOS_SELETIVOS (PRS_CODIGO);
