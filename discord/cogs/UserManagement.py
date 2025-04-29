import logging

import discord
from discord.commands import Option, slash_command
from discord.ext import commands

from db.package.crud import discord_thread_timeline_channels as db_crud
from db.package.session import get_db


class UserManagement(commands.Cog):
    def __init__(self, bot):
        self.bot = bot
        self.logger = logging.getLogger(type(self).__name__)
        self.logger.setLevel(logging.DEBUG)

    @slash_command(
        name="add_roles_to_everyone", description="全てのメンバーにロールを一括付与"
    )
    @commands.has_permissions(administrator=True)
    async def add_roles_to_everyone(
        self,
        ctx: discord.commands.context.ApplicationContext,
        role: Option(discord.Role, "ロール", required=True),
    ):
        guild = ctx.guild
        async for member in guild.fetch_members():
            try:
                await member.add_roles(role)
            except Exception as e:
                self.logger.error(f"メンバーにロールを付与できませんでした: {e}")
                continue

        await ctx.respond(
            f"{role.name}を全てのメンバーに付与しました。", ephemeral=True
        )


def setup(bot):
    return bot.add_cog(UserManagement(bot))
