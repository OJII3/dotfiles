return {
	"goolord/alpha-nvim",
	dependencies = {
		{ "nvim-tree/nvim-web-devicons" },
		{ "3rd/image.nvim" },
	},
	lazy = false,
	config = function()
		local alpha = require("alpha")

		vim.api.nvim_set_hl(0, "CustomAlphaHeader", { fg = "#00ffff", bold = true })
		vim.api.nvim_set_hl(0, "CustomAlphaFooter", { fg = "#00ffff", bold = true })
		local dashboard = require("alpha.themes.dashboard")
		dashboard.section.header.val = {}
		dashboard.section.header.opts.hl = "CustomAlphaHeader"
		dashboard.section.footer.opts.hl = "CustomAlphaFooter"

		if os.getenv("TERM") == "xterm-kitty" then
			local api = require("image")
			-- local image = api.from_file("/home/ojii3/.config/nvim/media/NeovimShadowed.png", {
			-- 	x = vim.api.nvim_win_get_width(0) / 2 - 40,
			-- 	y = 5,
			-- 	width = 80,
			-- })
			local image = api.from_file("/home/ojii3/.config/nvim/media/hatsune-miku-chibi.png", {
				x = vim.api.nvim_win_get_width(0) / 2 - 20,
        y = 5,
			})
			if image ~= nil then
				-- dashboard.section.buttons.val = {}
				dashboard.section.header.val = {
					[[]],
					[[]],
					[[]],
					[[]],
					[[]],
					[[]],
					[[]],
					[[]],
					[[]],
					[[]],
					[[]],
					[[]],
					[[]],
					[[]],
					[[]],
					[[]],
					[[]],
					[[]],
					[[]],
					[[]],
					[[]],
					[[]],
					[[]],
					[[]],
					[[]],
				}

				vim.api.nvim_create_autocmd({ "User" }, {
					callback = function()
						image.render(image)
					end,
					pattern = "AlphaReady",
				})

				vim.api.nvim_create_autocmd({ "User" }, {
					callback = function()
						image.clear(image)
					end,
					pattern = "AlphaClosed",
				})

				-- dashboard.config.opts.noautocmd = true
				vim.cmd([[
          autocmd User AlphaReady echo 'Ready!'
        ]])
				alpha.setup(dashboard.config)
				return
			end
		end
		dashboard.section.buttons.val = {}
		dashboard.section.header.val = {
			[[                                                                                                                        ......:o'.                               ]],
			[[                                                                                                                     c:,,,;',cxxlc,                              ]],
			[[                                                                                                                    '',;,,...,dol::,                             ]],
			[[                                                                                                                   ,l''.'',;''00k;'''                            ]],
			[[                                                                                                                  .dc:cc.  ,;lkk,'....                           ]],
			[[                                                                                                                  'll;cc..  .ll.  '....                          ]],
			[[                                                                                                                 .':l,.,,.,:,'c.  ......                         ]],
			[[                                                                                                                ...',, .:dd,,'.    '.....                        ]],
			[[                                                                                                                ...'., 'llcc;.. .  .'.....                       ]],
			[[                                                                                                               ..',',;'':;,.;;. .  .;''....                      ]],
			[[                                                                                                               .'cc:xo,:d::;dxddo   ,:'.....                     ]],
			[[                                                                                                              ..lodko.,lco:;,o0ko   .lc'....                     ]],
			[[                                                                                                               :oox:..xc,;;. ;00x    ;oc..  .                    ]],
			[[                      .;        ;.                                                                          . ;dxxkd'lxxc;l. ,00O.   .lo'.   .                   ]],
			[[                    .,l,'.      ;l;.                                           ;;;                         ..;l::;,;:lcdl,:c.;0Ok:    ;lc....  ;                 ]],
			[[                   ;odl;,,'     ;bcc:                                                                     ..,l';l:::oo:'.ldc;d0xdk    .co,..... .                ]],
			[[                   cddl;,;:,.   ;bccc.    :l.:'',.   :'''l.  .:''':. ox;   .dx.dx, ox:odxc'ldxxl.         .'dx;kKxOKO;;:,:d:cxXx:O;    ,dc........               ]],
			[[                   cccl;,;:;,.  ;llll.    :d     b .c     ;..c     ;:.kk.  dO' kO; xO:  ;OO'  oOc        ',kOdx0OKXXKx,.'ck000XOcxx    .lo'........              ]],
			[[                   cccl; .;;;;, ;llll.    :l     d.;d.....d.c'      d .kx lO:  kO; xO,  'OO.  cOl      .'.oKk0c:xOk0kOOd0Oll;OXOdok,    :l,.......'.             ]],
			[[                   lccl;  .;;;;;;looo.    :l     d..c       ';     .l  ;OdOo   kO; xO,  'OO.  cOl     .'.'lokd,::,:dc:o:od;''KXkdlxx    ,l'........'             ]],
			[[                   llll,    ,:;:;ldoo.    :l     d  '':..:'  ''...''    cdo    dx, x0'  .00.  :0l    .'.'odccc,....;. ...'';lxOkxddd    .c'........'             ]],
			[[                   clll;     '::;ldoo.                                                              .:..lxdo;k0Okx:,    l:OOO:.....     .;'..........            ]],
			[[                    .co;      .:;dl,                                                                :..;xkkd.O0kkOc.    .OOkOk          .'''''......;            ]],
			[[                      .;        ;'                                                                 ....cdxkxlO0kkO,.     c0kO0,         '';:;,'......            ]],
			[[                                                                                                   ;..,:lodx;0K00k'.     .000Ko        .',ooc:''....;            ]],
			[[                                                                                                  ....';:coxl0K00d;.      lKKKO.       .'ldoo:;'.....            ]],
			[[                                                                                                  ;...',,;d:x00kOko'      .0kkO,      .,:dool:;';. .             ]],
			[[                                                                                                  . .'''':x.dK0xOl::       :OxOd      :clllccc:;..;              ]],
			[[                                                                                                  ;..'''':o.xNKKx' ..       o00K:    ,dololccccc,,.              ]],
			[[                                                                                                  ..';,,,ld.0NXK'            lK0Xl   oxodddoodo:;.               ]],
			[[                                                                                                  .',cl::codKKKo              ;XXXl  ;:llooxxd;.                 ]],
			[[                                                                                                   .,ooodddoKKK'               ,KKK'  .'clloc'                   ]],
			[[                                                                                                     'lolcc.0KO                 :KKk    ;,,.                     ]],
			[[                                                                                                       .',,.KKd                  oK0;    ;                       ]],
			[[                                                                                                            O0d                   OOx.                           ]],
			[[                                                                                                            kkd,                  dxx:                           ]],
			[[                                                                                                            xdol.                :dlok                           ]],
			[[                                                                                                            :Oddl               .dodd:                           ]],
			[[                                                                                                             :;:                  :;:                            ]],
		}

		dashboard.config.opts.noautocmd = true
		vim.cmd([[
      autocmd User AlphaReady echo 'Ready!'
    ]])
		alpha.setup(dashboard.config)
	end,
}
