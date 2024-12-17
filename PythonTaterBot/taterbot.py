#! /usr/bin/python3
# this function uses the https://discordpy.readthedocs.io/en/stable/index.html
# python library for discord interaction

import discord
import re
import json
import random
import logging

logging.basicConfig(filename='BotLog.txt', filemode='a', level=logging.INFO, format='%(asctime)s %(levelname)s %(message)s')




logging.info('reading token file')
# read discord token from file (do _not_ put discord tokens in git!)
tokenfile = open("discordtoken.txt")
bot_token = tokenfile.readline()
tokenfile.close()

logging.info('token file read')
logging.info('reading copyright file')

# read copyright file
copyrightfile = open("copyright.txt")
copyright = copyrightfile.read()
copyrightfile.close()

logging.info('copyright file read')
logging.info('reading help file')

# read help file
helpfile = open("help.txt")
helptext = helpfile.read()
helpfile.close()

logging.info('help file read')
logging.info('reading cards file')

# read cards
cardfile = open("cards.json")
cards = json.load(cardfile)
cardfile.close()

logging.info('cards file read')

logging.info('reading coin flip results')
coinfile = open('coinflip.txt')
coininfo = coinfile.read()
coinfile.close()
logging.info('coin flip results file read')



documentname='Wayback Machine to the Crowdsource Tarot'
documenturl='https://web.archive.org/web/20160310181245/http://crowdsourcetarot.makeincense.com/cards.phtml'

messageprefix = ""

random.seed()

# regex for 'reading'
readparse = re.compile(r"!reading(\s+.*)?")
numparse = re.compile(r"\d+")
coinparse = re.compile(r"!(coins|shells)(\s+.*)?")



# name type desc upright reversed (optional)


def cardText(card):
    result = "**" + card['name'] + "**" + "\n" + "_" + card['desc'] + "_" + "\n"
    if 'reversed' not in card:
        result = result + "(no reverse) " + card['upright']
    elif random.randint(0,1) == 0:
        result = result + "(upright) " + card['upright']
    else:
        result = result + "(reversed) " + card['reversed']

    result = result + "\n"
    return result

def doReading(count):
    readingcards = random.sample(cards['cards'],count)
    result = ""
    for card in readingcards:
        result = result + cardText(card)
    return result



class MyClient(discord.Client):

    async def on_ready(self):
        logging.info('successfully logged into Discord as %s',self.user)

    async def on_message(self, message):

        if message.content == "!copyright":
            await message.channel.send(messageprefix + copyright)
            logging.info('user %s on channel %s requested copyright',message.author,message.channel)
        elif message.content == "!coinhelp":
            await message.channel.send(messageprefix + coininfo)
            logging.info('user %s on channel %s requested coin help',message.author,message.channel)
        elif message.content == "!help":
            await message.channel.send(messageprefix + helptext)
            logging.info('user %s on channel %s requsted help',message.author,message.channel)
        elif message.content == "!link":
            await message.channel.send(messageprefix + "[" + documentname + "](" + documenturl + ")")
            logging.info('user %s on channel %s requested link to cards reference',message.author,message.channel)

        matcher = coinparse.match(message.content)
        if matcher:
            hcount = 0
            for idx in range(4):
                if random.randint(0,1) == 1:
                    hcount = hcount + 1
            coinmessage = ""
            if hcount == 0:
                coinmessage = "XXXX - NO. Stop divining on this topic now."
            elif hcount == 1:
                coinmessage = "OXXX - No.  You may ask more questions for clarity."
            elif hcount == 2:
                coinmessage = "OOXX - Yes."
            elif hcount == 3:
                coinmessage = "OOOX - First throw: Maybe, Ask again. Second throw: yes with conditions, ask more questions."
            elif hcount == 4:
                coinmessage = "OOOO - Yes!  With Blessings!"
            else:
                coinmessage = "???? - Wow!  Tell Albert about this, this should never happen"

            logging.info('user %s on channel %s requested coinflip',message.author,message.channel)
            await message.channel.send(messageprefix + coinmessage)

        matcher = readparse.match(message.content)
        if matcher:
            # if we get here, we know that message.content starts with !reading, and if
            # there are more characters in the test, there is whitespace after the reading
            cardcount = 3
            wordlist = message.content.split()

            # if the second word is a number, we want to use that as the wordcount
            if len(wordlist) > 1:
                nummatch = numparse.match(wordlist[1])
                if nummatch:
                    cardcount = int(wordlist[1])

            logging.info('user %s on channel %s requested reading on %s cards',message.author,message.channel,cardcount)

            if cardcount > len(cards['cards']):
                await message.channel.send("Sorry, the deck doesn't have that many cards.")
            else:
                readingMessage = messageprefix + doReading(cardcount)
                await message.channel.send(readingMessage)




intents = discord.Intents.default()
logging.info('starting bot server')
client = MyClient(intents=intents)
client.run(bot_token)
