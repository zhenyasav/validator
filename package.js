Package.describe({
  name: 'zhenya:validator',
  summary: 'validate user input',
  version: '0.0.1',
});

Package.onUse(function(api) {
	api.use([
		'coffeescript',
		'less',
		'templating'
		]);

	api.addFiles([
		'validator.import.less', 
		'validator.coffee'
		],'client');
});

Package.onTest(function(api) {
  api.use('tinytest');
});
