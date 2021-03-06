# =================================
# Misc Configuration

envConfig = process.env
githubAuthString = "client_id=#{envConfig.DOCPAD_GITHUB_CLIENT_ID}&client_secret=#{envConfig.DOCPAD_GITHUB_CLIENT_SECRET}"

# =================================
# DocPad Configuration

module.exports =
	regenerateEvery: 1000*60*60  # hour

	# =================================
	# Template Data
	# These are variables that will be accessible via our templates
	# To access one of these within our templates, refer to the FAQ: https://github.com/bevry/docpad/wiki/FAQ

	templateData:
		# Site Data
		site:
			url: "http://tosh.no"
			title: "Torstein Bjørnstad"
			author: "Torstein Bjørnstad"
			email: "tosh@tosh.no"
			description: """
				Website of Torstein Bjørnstad. .NET Consultant at Webstep AS.
				"""
			keywords: """
				tosh, toshb, torstein bjørnstad, c#, javascript
				"""

			text:
				heading: "Torstein Bjørnstad"
				subheading: '''
					<t render="html.coffee">
						link = @getPreparedLink.bind(@)
						text """
							.NET Consultant at #{link 'webstep'}. #{link 'contact'}.
							"""
					</t>
					'''
				about: '''
					<t render="html.coffee">
						link = @getPreparedLink.bind(@)
						text """
							This website was created with #{link 'bevry'}’s #{link 'docpad'} and is #{link 'source'}
							"""
					</t>
					'''
				copyright: '''
					<t render="html.md">
						Unless stated otherwise; all works are Copyright © 2013 [Torstein Bjørnstad](http://www.tosh.no) and licensed [permissively](http://en.wikipedia.org/wiki/Permissive_free_software_licence) under the [MIT License](http://creativecommons.org/licenses/MIT/) for code and the [Creative Commons Attribution 3.0 Unported License](http://creativecommons.org/licenses/by/3.0/) for everything else (including content, media and design), enjoy!
					</t>
					'''

			services:
				twitterTweetButton: "ToshB"
				twitterFollowButton: "ToshB"
				githubFollowButton: "ToshB"
				disqus: 'toshb'
				googleAnalytics: 'UA-16411848-1'
				
			social:
				"""
				facebook
				linkedin
				github
				twitter
				""".trim().split('\n')

			scripts: """
				/vendor/jquery-1.7.1.js
				/vendor/fancybox-2.0.5/jquery.fancybox.js
				/scripts/script.js
				""".trim().split('\n')

			feeds: [
					href: 'http://feeds.feedburner.com/toshb.atom'
					title: 'Blog Posts'
				,
					href: 'https://github.com/toshb.atom'
					title: 'GitHub Activity'
				,
					href: 'https://api.twitter.com/1/statuses/user_timeline.atom?screen_name=toshb&count=20&include_entities=true&include_rts=true'
					title: 'Tweets'
			]

			pages: [
					url: '/'
					match: '/index'
					label: 'home'
					title: 'Return home'
				,
					url: '/projects'
					label: 'projects'
					title: 'View projects'
				,
					url: '/blog'
					label: 'blog'
					title: 'View articles'
			]

			links:
				webstep:
					text: 'Webstep AS'
					url: 'http://www.webstep.no'
					title: 'Visit Website'
				docpad:
					text: 'DocPad'
					url: 'http://docpad.org'
					title: 'Visit Website'
				bevry:
					text: 'Bevry'
					url: 'http://bevry.me'
					title: 'Visit Website'
				source:
					text: 'open-source'
					url: 'https://github.com/toshb/toshb.docpad'
					title: 'View Website Source'
				contact:
					text: 'Contact'
					url: 'mailto:tosh@tosh.no'
					title: 'Contact me'
					cssClass: 'contact-button'

		# Link Helper
		getPreparedLink: (name) ->
			link = @site.links[name]
			renderedLink = """
				<a href="#{link.url}" title="#{link.title}" class="#{link.cssClass or ''}">#{link.text}</a>
				"""
			return renderedLink

		# Meta Helpers
		getPreparedTitle: -> if @document.title then "#{@document.title} | #{@site.title}" else @site.title
		getPreparedAuthor: -> @document.author or @site.author
		getPreparedEmail: -> @document.email or @site.email
		getPreparedDescription: -> @document.description or @site.description
		getPreparedKeywords: -> @site.keywords.concat(@document.keywords or []).join(', ')

	# =================================
	# Collections

	collections:
		pages: ->
			@getCollection('documents').findAllLive({pageOrder:$exists:true},[pageOrder:1])

		posts: ->
			@getCollection('documents').findAllLive({relativeOutDirPath:'blog'},[date:-1])


	# =================================
	# Events

	events:
		serverExtend: (opts) ->
			# Prepare
			docpadServer = opts.server

			# ---------------------------------
			# Server Configuration

			# Redirect Middleware
			docpadServer.use (req,res,next) ->
				if req.headers.host in ['www.tosh.no','tosh-web.herokuapp.com']
					res.redirect 301, 'http://tosh.no'+req.url
				else
					next()

			# ---------------------------------
			# Server Extensions

			# Demos
			#docpadServer.get /^\/sandbox(?:\/([^\/]+).*)?$/, (req, res) ->
			#	project = req.params[0]
			#	res.redirect 301, "http://toshb.github.com/#{project}/demo/"
				# ^ github pages don't have https

			# Projects
			#docpadServer.get /^\/projects\/(.*)$/, (req, res) ->
			#	project = req.params[0] or ''
			#	res.redirect 301, "https://github.com/toshb/#{project}"

			#docpadServer.get /^\/(?:g|gh|github)(?:\/(.*))?$/, (req, res) ->
			#	project = req.params[0] or ''
			#	res.redirect 301, "https://github.com/toshb/#{project}"

			# Twitter
			#docpadServer.get /^\/(?:t|twitter|tweet)(?:\/(.*))?$/, (req, res) ->
			#	res.redirect 301, "https://twitter.com/toshb"
			

	# =================================
	# Plugin Configuration

	plugins:
		feedr:
			feeds:
				'github-profile':
					url: "https://api.github.com/users/toshb?#{githubAuthString}"
				'toshb-projects':
					url: "https://api.github.com/users/toshb/repos?per_page=100&#{githubAuthString}"
				'github':
					url: "https://github.com/toshb.atom"
				'twitter':
					url: "https://api.twitter.com/1/statuses/user_timeline.json?screen_name=toshb&count=20&include_entities=true&include_rts=true"

