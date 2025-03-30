return {
	'nvim-java/nvim-java',
	config = function()
    -- Set up nvim-java before LSP configuration
    require('java').setup()
  end

}
