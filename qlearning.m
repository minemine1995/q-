%机器人走房间Q-learning的实现
%% 基本参数
clear;
clc;
episode=300; %探索的迭代次数
alpha=0.8;%更新步长
gamma=1;%折扣因子
state_num=6;
action_num=6;
final_state=6;%目标房间
Reward_table = [
-inf -inf -inf -6 -8 -inf; %1
-inf -inf -9 -5 -inf -7; %2
-inf -9 -inf -3 -inf -inf; %3
-6  -5   -3  -inf  -7 -inf; %4
-8 -inf -inf -7 -inf -5;
-inf -10 -inf -inf -10 0 %6
];
%% 更新Q表
%initialize Q(s,a)
Q_table=zeros(state_num,action_num);
for i=1:episode
   
    %randomly choose a state
    current_state=randperm(state_num,1);
    while current_state~=final_state
        %randomly choose an action from current state
        optional_action=find(Reward_table(current_state,:)>=-10);
        chosen_action=optional_action(randperm(length(optional_action),1));
        %take action, observe reward and next state
        r=Reward_table(current_state,chosen_action);
        next_state=chosen_action;
        %update Q-table
        next_possible_action=find(Reward_table(next_state,:)>=-10);
        maxQ=max(Q_table(next_state,next_possible_action));
        Q_table(current_state,chosen_action)=Q_table(current_state,chosen_action)+alpha*(r+gamma*maxQ-Q_table(current_state,chosen_action));
        current_state=next_state;
    end
     if i==episode/2
        Reward_table = [
-inf -inf -inf -6 -8 -inf; %1
-inf -inf -9 -inf -inf -7; %2
-inf -9 -inf -3 -inf -inf; %3
-6  -inf   -3  -inf  -7 -inf; %4
-8 -inf -inf -7 -inf -5; 
-inf -inf -inf -inf -inf 50 %6
];
Q_table
    end
end
Q_table
 %% 选择最优路径
 %randomly choose a state
% currentstate=randperm(state_num,1);
% fprintf('Initialized state %d\n',currentstate);
%choose action which satisfies Q(s,a)=max{Q(s,a')}
% while currentstate~=final_state
%      [maxQtable,index]=max(Q_table(currentstate,:));
%      chosenaction=index;
%      nextstate=chosenaction;
%      fprintf('the robot goes to %d\n',nextstate);
%      currentstate=nextstate;
% end

