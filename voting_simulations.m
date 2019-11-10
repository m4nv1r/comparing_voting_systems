function res = voting_simulations(nvoters,nridings,nparties,TOL,N)
  %'nvoters' refers to the number of voters. 'nridings' refers to the number of
  % ridings. 'nparties' refers to the number of political parties while N refers to
  % the number of simulations.
  res = zeros(N,6); % Will store misrepresentation ratio for each voting system
  % for each simulation. First three strategic, next three genuine.
  voter_riding = zeros(nvoters,1); %voters will be assinged to each riding.
  nvoters_in_riding = zeros(1,nridings); %number of voters in each riding.
  % assign voters to ridings
  for i = 1:nvoters
    voter_riding(i,1) = randi([1,nridings]);
    nvoters_in_riding(1, voter_riding(i,1)) = nvoters_in_riding(1, voter_riding(i,1)) + 1;
  end
  pref_cand = zeros(nvoters,nparties); %rating that each voter assigns each politician.
  pref_party = zeros(nvoters,1); % party preference for each voter.
  for a = 1:N
    % first the ratings for the candidates will be generated.
    pref_cand = randi([0,9],nvoters,nparties);
    % now the preffered party will be determined
    % by identifying the party with the highest rating.
    [mpp,pref_party] = max(pref_cand,[],2);
    
    % in case more than one party got the highest rating
    % the following for loop will randomly select one of them.
    for i = 1:nvoters
       potential_pref = (pref_cand(i,:)==mpp(i,1));
      if sum(potential_pref) ~= 1
        idx = find(potential_pref);
        new_pref = randi([1,length(idx)]);
        pref_party(i,1) = idx(new_pref);
      end
    end
    
    % the following vectors will store the results of the various voting systems
    fptp_strategic = zeros(1,nparties);
    fptp_actual = zeros(1,nparties);
    run_off_strategic = zeros(1,nparties);
    run_off_actual = zeros(1,nparties);
    mmp_strategic = zeros(1,nparties);
    mmp_actual = zeros(1,nparties);
    run_off_second_round_strategic = zeros(nridings,nparties);
    run_off_second_round_actual = zeros(nridings,nparties);
    mmp_second_round = zeros(1,nparties);
    average_rating_per_riding = zeros(nridings,nparties);
    total_votes_party_actual = zeros(nridings,nparties);
    most_popular_per_riding = zeros(nridings,1);
    second_most_popular_per_riding = zeros(nridings,1);
    support_per_party = zeros(1,nparties);
    votes_per_party_strategic = zeros(1,nparties);
    votes_per_party_actual = zeros(1,nparties);
    
    % amount of voters that support each party, average rating per party in each riding
    % and the amount of votes for each party per riding (if they vote 
    % for the party they genuinly want to vote for) will now be determined
    for i = 1:nvoters
      support_per_party(1,pref_party(i,1)) = support_per_party(1,pref_party(i,1)) + 1;
      average_rating_per_riding(voter_riding(i,1),:) = average_rating_per_riding(voter_riding(i,1),:) + pref_cand(i,:);
      total_votes_party_actual(voter_riding(i,1), pref_party(i,1)) = total_votes_party_actual(voter_riding(i,1), pref_party(i,1)) + 1;
    end
    
    % now the most popular and the second most popular party in each riding
    % will be determined.
    for i = 1:nridings
      average_rating_per_riding(i,:) = average_rating_per_riding(i,:)/nvoters_in_riding(1,i);
      [max1, most_popular_per_riding(i,1)] = max(total_votes_party_actual(i,:));
      total_votes_party_actual(i,most_popular_per_riding(i,1)) = -Inf;
      [max2, second_most_popular_per_riding(i,1)] = max(total_votes_party_actual(i,:));
      total_votes_party_actual(i,most_popular_per_riding(i,1)) = max1;
    end
    
    % determine the amount of votes for each party if voters do not vote
    % strategically
    for i = 1:nridings
      for j = 1:nparties
        votes_per_party_actual(1,j) = votes_per_party_actual(1,j) + total_votes_party_actual(i,j);
      end
    end
    
    % results of the second round of run off voting
    for i=1:nvoters
      % voting based on actual preferences
      if pref_cand(i, most_popular_per_riding(voter_riding(i,1),1)) > pref_cand(i, second_most_popular_per_riding(voter_riding(i,1),1))
        run_off_second_round_actual(voter_riding(i,1), most_popular_per_riding(voter_riding(i,1),1)) = run_off_second_round_actual(voter_riding(i,1), most_popular_per_riding(voter_riding(i,1),1)) + 1;
      elseif pref_cand(i, second_most_popular_per_riding(voter_riding(i,1),1)) > pref_cand(i, most_popular_per_riding(voter_riding(i,1),1))
        run_off_second_round_actual(voter_riding(i,1), second_most_popular_per_riding(voter_riding(i,1),1)) = run_off_second_round_actual(voter_riding(i,1), second_most_popular_per_riding(voter_riding(i,1),1)) + 1;
      else
        coin_flip = randi([1,2]);
        if coin_flip == 1
          run_off_second_round_actual(voter_riding(i,1), most_popular_per_riding(voter_riding(i,1),1)) = run_off_second_round_actual(voter_riding(i,1), most_popular_per_riding(voter_riding(i,1),1)) + 1;
        else
          run_off_second_round_actual(voter_riding(i,1), second_most_popular_per_riding(voter_riding(i,1),1)) = run_off_second_round_actual(voter_riding(i,1), second_most_popular_per_riding(voter_riding(i,1),1)) + 1;
        end
      end
      
        % strategic voting
      if pref_party(i,1) == most_popular_per_riding(voter_riding(i,1),1)
        run_off_second_round_strategic(voter_riding(i,1), pref_party(i,1)) = run_off_second_round_strategic(voter_riding(i,1), pref_party(i,1)) + 1;
      elseif pref_party(i,1) == second_most_popular_per_riding(voter_riding(i,1),1)
        run_off_second_round_strategic(voter_riding(i,1), pref_party(i,1)) = run_off_second_round_strategic(voter_riding(i,1), pref_party(i,1)) + 1;
      else
        pd1 = abs(pref_cand(i, pref_party(i,1))-pref_cand(i,most_popular_per_riding(voter_riding(i,1),1)));
        pd2 = abs(pref_cand(i, pref_party(i,1))-pref_cand(i,second_most_popular_per_riding(voter_riding(i,1),1)));
        mpd = min([pd1,pd2]);
        if mpd <= TOL
          if mpd == pd1
            run_off_second_round_strategic(voter_riding(i,1), most_popular_per_riding(voter_riding(i,1),1)) = run_off_second_round_strategic(voter_riding(i,1), most_popular_per_riding(voter_riding(i,1),1)) + 1;
          else
            run_off_second_round_strategic(voter_riding(i,1), second_most_popular_per_riding(voter_riding(i,1),1)) = run_off_second_round_strategic(voter_riding(i,1), second_most_popular_per_riding(voter_riding(i,1),1)) + 1;
          end
        else
          run_off_second_round_strategic(voter_riding(i,1), pref_party(i,1)) = run_off_second_round_strategic(voter_riding(i,1), pref_party(i,1)) + 1;
        end
      end
    end
    
    % now the results that each voting system would give will be determined
    for i = 1:nridings
      % results of first past the post (voting based on actual views)
      [max1, index1] = max(total_votes_party_actual(voter_riding(i,1), :));
      fptp_actual(1, index1) = fptp_actual(1, index1) + 1;
      
      % results of run off voting (actual)
      if (max1/nvoters_in_riding(1,i)) >= .5
        run_off_actual(1, index1) = run_off_actual(1,index1) + 1;
      else
        if run_off_second_round_actual(i, most_popular_per_riding(i,1)) > run_off_second_round_actual(i, second_most_popular_per_riding(i,1))
          run_off_actual(1, most_popular_per_riding(i,1)) = run_off_actual(1, most_popular_per_riding(i,1)) + 1;
        elseif run_off_second_round_actual(i, second_most_popular_per_riding(i,1)) > run_off_second_round_actual(i, most_popular_per_riding(i,1))
          run_off_actual(1, second_most_popular_per_riding(i,1)) = run_off_actual(1, second_most_popular_per_riding(i,1)) + 1;
        else
          coin_flip = randi([1,2]);
          if coin_flip == 1
            run_off_actual(1, most_popular_per_riding(i,1)) = run_off_actual(1, most_popular_per_riding(i,1)) + 1;
          else
            run_off_actual(1, second_most_popular_per_riding(i,1)) = run_off_actual(1, second_most_popular_per_riding(i,1)) + 1;
          end
        end
      end
      
      % results of first past the post (strategic voting)
      [max1, index1] = max(run_off_second_round_strategic(i, :));
      fptp_strategic(1, index1) = fptp_strategic(1, index1) + 1;
      
      % results of run off voting (strategic voting)
      if (max1/nvoters_in_riding(1,i)) >= .5
        run_off_strategic(1, index1) = run_off_strategic(1,index1) + 1;
      else
        if run_off_second_round_strategic(i, most_popular_per_riding(i,1)) > run_off_second_round_strategic(i, second_most_popular_per_riding(i,1))
          run_off_strategic(1, most_popular_per_riding(i,1)) = run_off_strategic(1, most_popular_per_riding(i,1)) + 1;
        elseif run_off_second_round_strategic(i, second_most_popular_per_riding(i,1)) > run_off_second_round_strategic(i, most_popular_per_riding(i,1))
          run_off_strategic(1, second_most_popular_per_riding(i,1)) = run_off_strategic(1, second_most_popular_per_riding(i,1)) + 1;
        else
          coin_flip = randi([1,2]);
          if coin_flip == 1
            run_off_strategic(1, most_popular_per_riding(i,1)) = run_off_strategic(1, most_popular_per_riding(i,1)) + 1;
          else
            run_off_strategic(1, second_most_popular_per_riding(i,1)) = run_off_strategic(1, second_most_popular_per_riding(i,1)) + 1;
          end
        end
      end
    end
    
    % results of MMP (no strategic voting)
    mmp_actual = fptp_actual;
    temp = fptp_actual;
    c = nridings;
    converged = 0;
    while (converged == 0)
      if c <= 0
        converged = 1;
        break
      end
      [max1, index1] = max(temp);
      while (mmp_actual(1, index1)/(2*nridings)) < (votes_per_party_actual(1,index1)/nvoters)
        if c <= 0
          converged = 1;
          break
        end
        mmp_actual(1, index1) = mmp_actual(1, index1) + 1;
        c = c - 1;
      end
      temp(1, index1) = -Inf;
      if c <= 0
        converged = 1;
      end
    end
    
    % resultd of MMP (strategic voting)
    mmp_strategic = fptp_strategic;
    temp = fptp_strategic;
    c = nridings;
    converged = 0;
    while (converged == 0)
      if c <= 0
        converged = 1;
        break
      end
      [max1, index1] = max(temp);
      while (mmp_strategic(1, index1)/(2*nridings)) < votes_per_party_actual(1,index1)/nvoters
        if c <= 0
          converged = 1;
          break
        end
        mmp_strategic(1, index1) = mmp_strategic(1, index1) + 1;
        c = c - 1;
      end
      temp(1, index1) = -Inf;
      if c <= 0
        converged = 1;
      end
    end
    
    % determine the amount of votes for each part if voters vote
    % strategicallly
    for i = 1:nridings
      for j = 1:nparties
        votes_per_party_strategic(1,j) = votes_per_party_strategic(1,j) + run_off_second_round_strategic(i,j);
      end
    end
    
    % misrepresentation ratio
    for i = 1:nparties
      if votes_per_party_strategic(1,i) > 0
        res(a,1) = res(a,1) + (((fptp_strategic(1,i)/nridings)-(votes_per_party_strategic(1,i)/nvoters))^2)/(votes_per_party_strategic(1,i)/nvoters);
        res(a,2) = res(a,2) + (((run_off_strategic(1,i)/nridings)-(votes_per_party_strategic(1,i)/nvoters))^2)/(votes_per_party_strategic(1,i)/nvoters);
        res(a,3) = res(a,3) + (((mmp_strategic(1,i)/(2*nridings))-(votes_per_party_strategic(1,i)/nvoters))^2)/(votes_per_party_strategic(1,i)/nvoters);
      end
      if votes_per_party_actual(1,i) > 0
        res(a,4) = res(a,4) + (((fptp_actual(1,i)/nridings)-(votes_per_party_actual(1,i)/nvoters))^2)/(votes_per_party_actual(1,i)/nvoters);
        res(a,5) = res(a,5) + (((run_off_actual(1,i)/nridings)-(votes_per_party_actual(1,i)/nvoters))^2)/(votes_per_party_actual(1,i)/nvoters);
        res(a,6) = res(a,6) + (((mmp_actual(1,i)/(2*nridings))-(votes_per_party_actual(1,i)/nvoters))^2)/(votes_per_party_actual(1,i)/nvoters);
      end
    end
  end
end