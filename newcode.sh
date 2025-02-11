#!/bin/bash

airflow_dag_dir="C:/Users/nithinsharma.julakan/Downloads/test2"
github_repo_url="https://github.com/nithin-julakanti/testnew.git"
github_repo_name="testnew"
read -p "Enter the date (e.g., 'Feb 9'): " today

if [ ! -d "$airflow_dag_dir" ]; then
  echo "Directory does not exist."
  exit 1
fi

git clone "$github_repo_url" C:/Users/nithinsharma.julakan/Downloads/clone

cd "$github_repo_name"

if git branch --list dev; then    
  git checkout dev
else
  git checkout -b dev
fi

branches=$(git branch -r )
for branch in $branches; do
  if [ "$branch" == "dev" ]; then
    git checkout dev
    break
  fi
done

new_dags=$(ls -l "$airflow_dag_dir" | grep "$today" | grep '\.py$' | awk '{print $9}')

if [ -z "$new_dags" ]; then  
  echo "No new DAGs are found on $today."
  exit 1
else
  echo "List of new DAGs added on $today:"
  echo "$new_dags"

  cd C:/Users/nithinsharma.julakan/Downloads/newcode/testnew
  git pull origin dev
  cd "$github_repo_name"
  for dag in $new_dags; do
    cp "$airflow_dag_dir/$dag" .
    git add "$dag" 
  done
  
  git status
  git commit -m "On $today, new DAGs have been committed."
  git push -u origin dev 
  echo "Pushed $(echo $new_dags) DAGs on $today to the GitHub repository"
fi
