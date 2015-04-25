Package.describe({
  name: 'zhenya:validator',
  summary: 'validate user input',
  version: '0.0.1',
});

Package.onUse(function(api) {

	api.versionsFrom('1.0');

	api.use([
		'coffeescript',
		'less',
		'templating'
		], 'client');

	api.addFiles([
		'validator.import.less', 
		'validator.coffee'
		],'client');
});

Package.onTest(function(api) {
  api.use('tinytest');
});
