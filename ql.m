clear
clc
states=8;       %��ʼ����
actions=8;      %��������
final_state=8; %Ŀ��״̬
episode=100;    %��������
gamma=1;        %�ۿ�ϵ��
alpha=0.8;      %ѧϰ����
p_max=zeros(states,actions);%��Qֵ��ѡ���ֵ���ж����ĸ���
T=5;              %�˻��¶�
reward=-1*[inf	inf	47	inf	inf	24	inf	inf;
inf	inf	55	31	31	inf	74	79;
47	55	inf	88	23	25	66	inf;
inf	31	88	inf	inf	120	inf	29;
inf	31	23	inf	inf	inf	42	inf;
24	inf	25	120	inf	inf	inf	inf;
inf	74	66	inf	42	inf	inf	66;
inf	79	inf	29	inf	inf	66	inf];
tic
Q_table=zeros(states,states);
for i=1:episode
    current_state=randperm(states,1);                           %���ָ��һ����ʼ�ڵ�
    while current_state~=final_state;                           %��ǰ�ڵ��Ƿ�ΪĿ��ڵ�
        optinal_action=find(reward(current_state,:)>=-1000);      %��ǰ״̬�Ŀ��ܶ�����
        if length(optinal_action)==0                            %�жϵ�ǰ״̬�Ŀ��ܶ������Ƿ�Ϊ��
           print("not connected")
           break
        else
            next_action=choose_next_action(Q_table,current_state,optinal_action,p_max);     %�����˻��㷨ѡ��ǰ״̬��һ������
            next_state_optinal=find(reward(next_action,:)>=-1000);                                    
            maxQ=max(Q_table(next_action,next_state_optinal));
            Q_current=Q_table(current_state,next_action);
            Q_table(current_state,next_action)=(1-alpha)*Q_table(current_state,next_action)+alpha*(reward(current_state,next_action)+gamma*maxQ);
            Q_next=Q_table(current_state,next_action);
            p_max(current_state,next_action)=pmax(Q_current,Q_next,T);
            current_state=next_action;
        end
    
    end
    if i==episode/2
                reward=-1*[inf	inf	47	inf	inf	24	inf	inf;
inf	inf	55	31	31	inf	74	79;
47	55	inf	88	23	25	66	inf;
inf	31	88	inf	inf	120	inf	59;
inf	31	23	inf	inf	inf	42	inf;
24	inf	25	120	inf	inf	inf	inf;
inf	74	66	inf	42	inf	inf	66;
inf	79	inf	59	inf	inf	66	inf];

             Q_table
    end
end
Q_table
toc

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