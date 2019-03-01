clear
clc
states=6;       %初始数量
actions=6;      %动作数量
final_state=6; %目标状态
episode=40;    %迭代次数
gamma=1;        %折扣系数
alpha=0.8;      %学习速率
p_max=zeros(states,actions);%按Q值表选最大值进行动作的概率
T=1;              %退火温度
reward=[
%  1    2    3    4    5     6 
 -inf -inf -inf -6   -8    -inf; %1
 -inf -inf -9   -5   -inf  -7  ; %2
 -inf -9   -inf -3   -inf  -inf; %3
 -6   -5   -3   -inf  -7   -inf; %4
 -8   -inf -inf -7   -inf  -5  ; %5
 -inf -10  -inf -inf -10   -inf     %6
 ];
Q_table=zeros(states,states);
for i=1:episode
    current_state=randperm(states,1);                           %随机指定一个起始节点
    while current_state~=final_state;                           %当前节点是否为目标节点
        optinal_action=find(reward(current_state,:)>=-10);      %当前状态的可能动作集
        if length(optinal_action)==0                            %判断当前状态的可能动作集是否为空
           print("not connected")
           break
        else
            next_action=choose_next_action(Q_table,current_state,optinal_action,p_max);     %根据退火算法选择当前状态的一个动作
            next_state_optinal=find(reward(next_action,:)>=-10);                                    
            maxQ=max(Q_table(next_action,next_state_optinal));
            Q_current=Q_table(current_state,next_action);
            Q_table(current_state,next_action)=(1-alpha)*Q_table(current_state,next_action)+alpha*(reward(current_state,next_action)+gamma*maxQ);
            Q_next=Q_table(current_state,next_action);
            p_max(current_state,next_action)=pmax(Q_current,Q_next,T);
            current_state=next_action;
        end
    
    end
    if i==episode/2
                reward=[
                %  1    2    3    4    5     6 
                 -inf -inf -inf -6   -8    -inf; %1
                 -inf -inf -9   -5   -inf  -7  ; %2
                 -inf -9   -inf -3   -inf  -inf; %3
                 -6   -5   -3   -inf  -7   -8; %4
                 -8   -inf -inf -7   -inf  -5  ; %5
                 -inf -10  -inf -8 -10   -inf     %6
                 ];
             Q_table
            end
end
Q_table

function [next_action]=choose_next_action(Q_table,current_state,optinal_action,p_max)
    [max_Q,max_action]=max(Q_table(current_state,optinal_action));
    if rand<=p_max(current_state,optinal_action(max_action))
    next_action=optinal_action(randperm(length(optinal_action),1));
    else
        next_action=optinal_action(max_action);
    end
end

function [p_max]=pmax(Q_current,Q_next,T)
p_max=exp(-abs((Q_current-Q_next)/T/Q_next));
end