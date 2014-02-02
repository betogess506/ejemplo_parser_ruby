# encoding: utf-8

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'normalize' 
require 'twitter'  


file = File.read("config.xml")
xml = Nokogiri::XML(file)

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "#{xml.xpath("//consumer_key").text}"
  config.consumer_secret     = "#{xml.xpath("//consumer_secret").text}"
  config.access_token        = "#{xml.xpath("//access_token").text}"
  config.access_token_secret = "#{xml.xpath("//access_token_secret").text}"
end


sitios=["http://www.everardoherrera.com/","http://www.aldia.cr/" ]
palabras_a_eliminar=["(FOTOS)","(VIDEOS)","(VIDEO)"]

count=0

sitios.each{|urlDelSitio| 

			puts urlDelSitio

			pageToParse= Nokogiri::HTML(open(urlDelSitio)) 
			
			case count

				when 0 #Everardo
					titulares = pageToParse.css('.contentheading').css('.contentpagetitle')
				
				when 1 #Al Dia
					titulares = pageToParse.css('#main.document1').css('#container').css('h2').css('.headline').css('a').css('.lnk')

				when 2 #Monumental
					titulares = pageToParse.css("#{instrucciones[count]}")

			end 
			
			titulares.each {|unTitular| texto= unTitular.text.strip
							
							palabras_a_eliminar.each{|x| texto.slice! "#{x}" }

							client.update("#{texto}")
							sleep rand(60..600)
			}
			
			count+=1

}


# Cosas que todavía me hacen falta por incluír:
# -Que incluya un short link con cada tweet, para esto abrá que reservar el espacio del tweet a 140 menos el tamaño del short link
# -(listo) Cambiar la configuración de la aplicación de twitter a un archivo xml



 


	

	




