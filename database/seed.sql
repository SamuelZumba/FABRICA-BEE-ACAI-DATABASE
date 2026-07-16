-- DADOS INICIAIS NECESSÁRIOS DE LOGIN 

INSERT INTO usuario (
  NOME,
  CPF,
  EMAIL,
  FOTO_PERFIL,
  CARGO,
  SENHA,
  NIVEL_ACESSO,
  STATUS_USUARIO,
  TEMA
) VALUES (
  'Administrador Bee Açaí',
  '123.456.789-01',
  'admin@beeacai.com.br',
  NULL,
  'Administrador',
  '$2y$12$LqK4s0e6.elLT1iMOlj73OYHsLULRrtkD74AuSTOMfsWRHtBXWDJ.',
  'Admin',
  'Ativo',
  'light'
);


INSERT INTO emissao_fiscal_config
  (PROVEDOR, STATUS_CONFIG, AMBIENTE, DATA_ATUALIZACAO)
VALUES
  ('Nuvem Fiscal', 'Nao configurado', 'Homologacao', NOW());
