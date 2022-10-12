import logging

import discord
from discord.ext import commands

from config import bot_config

logging.basicConfig(
    level=logging.INFO,
    format="[%(asctime)s][%(levelname)s] %(message)s"
)

# bot init
bot = commands.Bot(help_command=None,
                   case_insensitive=True,
                   activity=discord.Game("©Yuki Watanabe"),
                   intents=discord.Intents.all()
                   )

bot.load_extension("cogs.Admin")
bot.load_extension("cogs.CogManager")
bot.load_extension("cogs.MessageDeleter")
bot.load_extension("cogs.MessageExtractor")
bot.load_extension("cogs.PinMessage")
bot.load_extension("cogs.RoomAnnounce")
bot.load_extension("cogs.ThreadKeeper")
bot.load_extension("cogs.ThreadTimeline")


bot.run(bot_config.TOKEN)
