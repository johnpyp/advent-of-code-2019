for i in {1..13}
do
    cd $i
    crystal problem.cr > /dev/null 2>&1
    if [ $? -eq 0 ]
    then
      echo -e "\e[32m✔\e[0m Day $i successful"
    else
      echo -e "\e[31m✘\e[0m Day $i failed"
    fi
   cd ..
done
