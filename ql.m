clear
clc
states=6;       %��ʼ����
actions=6;      %��������
final_state=6; %Ŀ��״̬
episode=3000;    %��������
gamma=1;        %�ۿ�ϵ��
alpha=0.8;      %ѧϰ����
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
    current_state=randperm(states,1);                           %���ָ��һ����ʼ�ڵ�
    while current_state~=final_state;                           %��ǰ�ڵ��Ƿ�ΪĿ��ڵ�
        optinal_action=find(reward(current_state,:)>=-10);      %��ǰ״̬�Ŀ��ܶ�����
        if length(optinal_action)==0                            %�жϵ�ǰ״̬�Ŀ��ܶ������Ƿ�Ϊ��
           print("not connected")
           break
        else
            next_action=choose_next_action(current_state,optinal_action);     %�����˻��㷨ѡ��ǰ״̬��һ������
            next_state_optinal=find(reward(next_action,:)>=-10)    ;                                    
            maxQ=max(Q_table(next_action,next_state_optinal));
            Q_table(current_state,next_action)=(1-alpha)*Q_table(current_state,next_action)+alpha*(reward(current_state,next_action)+gamma*maxQ);
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

function [next_action]=choose_next_action(current_state,optinal_action)
    next_action=optinal_action(randperm(length(optinal_action),1));
end