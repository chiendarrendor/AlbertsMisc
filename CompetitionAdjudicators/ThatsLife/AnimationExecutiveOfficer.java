interface AnimationExecutiveOfficer
{
    public void Clear();
    public boolean IsAnimationDone();

    public void RemoveToken(int playerIndex,int tileId);
    public void AddToken(int playerIndex,int tileId);
    public void MoveToken(int playerIndex,int oldTileId,int newTileId);
    public void ShiftTile(int tileId,boolean goDownstream);
    public void ExitTile(int tileId,int owningPlayerId);
    public void RollDie(int roll,int playerId);
}
