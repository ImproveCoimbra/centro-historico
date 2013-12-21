[Website](http://centro.improvecoimbra.org) (beta)

## Sobre ##

Com este site, queremos promover a reabilitação do Centro Histórico de Coimbra.

Apresentamos informações sobre cada edifício relativamente ao seu estado de propriedade, disponibilidade, estado de conservação, funções que alberga, projectos de reabilitação já concretizados e os pontos de interesse que se encontram na sua envolvente.

Procuramos compilar e apresentar dados e informações a possíveis investidores com o objectivo de aumentar o número de habitantes no Centro Histórico.

Este é um projecto desenvolvido no [Improve Coimbra](http://improvecoimbra.org), um evento mensal com o objectivo de encontrar e implementar soluções para melhorar Coimbra.

## Desenvolvimento ##

Informações importantes sobre esta aplicação/repositório.

### Tecnologias ###

* Ruby on Rails
* MongoDB
* SASS (CSS)
* jQuery (Javascript)

### Produção ###

Para a execução desta aplicação em ambiente de produção é necessário definir as seguintes variáveis de ambiente:

* SECRET_TOKEN (do Ruby on Rails)
* ADMIN_PASSWORD (password de acesso à zona de administração, o username é "improve")
* S3_BUCKET (bucket da Amazon S3 para o alojamento de imagens)
* S3_ACCESS_KEY (dados de acesso S3 para o alojamento de imagens)
* S3_SECRET_KEY (dados de acesso S3 para o alojamento de imagens)
* MONGODB_URI (URI de acesso à base de dados MongoDB)

### Dados de acesso ###

Para aceder à zona de administração em ambiente de desenvolvimento, os dados de acesso são:

Username: improve
Password: improve13
