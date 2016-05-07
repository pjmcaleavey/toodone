require "too_done/version"
require "too_done/init_db"
require "too_done/user"
require "too_done/session"
require "too_done/list"
require "too_done/task"

require "thor"
require "pry"


module TooDone

  class App < Thor

    # desc "add 'TASK'", "Add a TASK to a todo list."
    # option :list, :aliases => :l, :default => "*default*",
    #   :desc => "The todo list which the task will be filed under."
    # option :date, :aliases => :d,
    #   :desc => "A Due Date in YYYY-MM-DD format."
    #
    # # tasks add "Test List" "Test task" "2015/12/12" true
    # def add(list_name, name, due_date = nil, completed = false)#default on boolean?
    #   #changes list_id to list_name to make more user friendly
    #
    #
    #   #list = List.find_by({name: list_name, user_id: current_user.id})
    #   #pass in user
    #   list = current_user.lists.find_or_create_by({name: list_name})
    #   #gives lists of the current user named dog
    #
    #   task = Task.find_or_create_by({list_id: list.id, name: name, due_date: due_date, completed: completed})#due_date - how pass in optional -put null?
    #   # find or create the right todo list
    #   # create a new item under that list, with optional date
    #   #do show after add
    #
    #   puts "#{task.name} has been added to #{list.name}"
    # end



    # THOR VERSION

    # tasks add "Test task" true --list "Test list" --date "2015/12/12"
    # ^^^^^^ How to run this method
    desc "add 'TASK'", "Add a TASK to a todo list."
    option :list, :aliases => :l, :default => "*default*",#what is this in the table?
      :desc => "The todo list which the task will be filed under."
    option :date, :aliases => :d,
      :desc => "A Due Date in YYYY-MM-DD format."
    def add(name)
      # add
      # find or create the right todo list
      # create a new item under that list, with optional date
        # Alternate code:
        # => puts "Add task to which list?"
        # => list = STDIN.gets.chomp.downcase
        # => thislist = List.find_or_create_by!(title: list, user_id: current_user.id)
        # => puts "Due Date?(YYYY-MM-DD)"
        # => duedate = STDIN.gets.chomp.downcase

        thisList = List.find_or_create_by(name: options[:list], user_id: current_user.id)
                                                #^^optional params    ^^makes sure logged in
                                    #if I don't provide list name, will look up by my id
        thisTask = Task.find_or_create_by(name: name, due_date: options[:date],
                                          completed: false, list_id: thisList.id)
        puts "Added task #{thisTask.name} to #{thisList.name} list"






      ##list_name = options[:list]#this instead of passing in parameters
      # list name = "Test"
      # list_name equals the value of list key in the options hash
      # options is a hash, it is created by thor every time you run a command
      # if you type --list "whatever" that equals options[:list]

      ##due_date = options[:date]#this instead of passing in parameters
      # due date equals "2015/12/12"

      ##list = current_user.lists.find_or_create_by({name: list_name})

      #list = current_user.lists.find_or_create_by({name: options[:list]})
      #^^this if don't do: list_name = options[:list]

      ##task = Task.find_or_create_by({list_id: list.id, name: name, due_date: due_date, completed: completed})
      #due_date - how pass in optional -put null?

      ##puts "#{task.name} has been added to #{list.name}"
    end



  #   def add_three_numbers(x, y, z = 55)
  #     x + y + z
  #   end
   #
  #   add_three_numbers(0, 0)
  #   # => 55
   #
  #  add_three_numbers(0, 0, 0)
  #  # => 0
   #
  #  add_three_numbers(1,1,2)
  #  # => 4

    # def my_method(hash)
    #   puts hash[:dog]
    # end
    # my_method({dog: "Rick"})
    # # this displays "Rick"
    #
    # my_method(dog: "Rick")
    # # this displays "Rick"
    #
    # my_method({"dog" => "Rick"})
    # # this displays nil
    #
    # my_hash = { dog: "Rick", person: "LALALALA" }
    # my_hash[:person]
    #
    # my_hash = { dog: :rick, person: :rickard}
    # my_hash[:dog]
    # # => :rick
    #
    #
    # my_hash = { "dog" => "Rick", "person" => "LALALALA" }
    # my_hash["dog"]
    #
    # my_hash = { :dog => "Rick", :person => "LALALALA" }
    # my_hash[:person]
    #
    # ### { dog: value} is shorthand for { :dog => value }
    #

#
#     homer_list.update(user_id: 1)
#
#    homer = User.find(2)
#=> <TooDone::User:0x007fc6c39acb30 id: 2, name: "Homer">
#
#     homer.lists.first
#     => #<TooDone::List:0x007fc6c38dd650 id: 3, name: "whatever", user_id: 2>
#     [31] pry(TooDone)> homer_list = homer.lists.first
#     homer_list = homer.lists.first
# => #<TooDone::List:0x007fc6c38dd650 id: 3, name: "whatever", user_id: 2>
#
# list = List.create({name: "whatever", user_id: 2})
# => #<TooDone::List:0x007fc6c34e1448 id: 3, name: "whatever", user_id: 2>
#
# list = List.find(2)
# => #<TooDone::List:0x007fc6c36c0610 id: 2, name: "dfsdfsdf", user_id: 1>
#
# homer_list.update(user_id: 1)
# => true
#





    desc "edit", "Edit a task from a todo list."
    option :list, :aliases => :l, :default => "*default*",
      :desc => "The todo list whose tasks will be edited."
    def edit
      thisList = List.find_by(name: options[:list], user_id: current_user.id)
      unless thisList
        puts "List doesn't exist"
        exit
      end
      thisTask = Task.where(list_id: thisList.id)
      unless thisTask.count > 0
        puts "There are no tasks in this list"
        exit
      end
      thisTask.each do |x|
        puts "#{x.id}, #{x.name}, #{x.due_date}, #{x.completed}"
      end
      puts "Which task do you want to edit? (task id)"
      task_to_edit = STDIN.gets.chomp.to_i

      edit_task = Task.find_by(id: task_to_edit)
      puts "What do you want the new name to be?"
      edit = STDIN.gets.chomp
      edit_task.update(name: "#{edit}")

      puts "#{edit_task.id}, #{edit_task.name}, #{edit_task.due_date}, #{edit_task.completed}"
      # edit
            # find the right todo list
            # BAIL if it doesn't exist and have tasks
            # display the tasks and prompt for which one to edit
            # allow the user to change the title, due date
      #list_name = options[:list]
    end





    desc "done", "Mark a task as completed."
    option :list, :aliases => :l, :default => "*default*",
      :desc => "The todo list whose tasks will be completed."
    def done
      thisList = List.find_by(name: options[:list], user_id: current_user.id)
      unless thisList
        puts "List doesn't exist"
        exit
      end
      thisTask = Task.where(list_id: thisList.id)#creating an array of tasks in this list
      unless thisTask.count > 0
        puts "There are no tasks in this list"
        exit
      end
      thisTask.each do |x|
        puts "#{x.id}, #{x.name}, #{x.due_date} #{x.completed}"
      end
      puts "Which task is complete? (task id)"
      task_number = STDIN.gets.chomp.to_i

      completed_task = Task.find_by(id: task_number)#look up by task id from user input
      completed_task.update(completed: true)
      puts "#{completed_task.name} is now complete"

      # done
            # find the right todo list
            # BAIL if it doesn't exist and have tasks
            # display the tasks and prompt for which one(s?) to mark done
    end




    desc "show", "Show the tasks on a todo list in reverse order."
    option :list, :aliases => :l, :default => "*default*",
      :desc => "The todo list whose tasks will be shown."
    option :completed, :aliases => :c, :default => false, :type => :boolean,
      :desc => "Whether or not to show already completed tasks."
    option :sort, :aliases => :s, :enum => ['history', 'overdue'],
      :desc => "Sorting by 'history' (chronological) or 'overdue'.
      \t\t\t\t\tLimits results to those with a due date."
    def show
      thisList = List.find_by(name: options[:list], user_id: current_user.id)
      thisTask = Task.where(list_id: thisList.id)
      thisTask.each do |x|
        puts "#{x.id}, #{x.name}, #{x.due_date}, #{x.completed}"
    end
    puts "Do you want to display in reverse order? y/n"
    reverse_order = STDIN.gets.chomp
    if reverse_order == "y"
      thisTask.reverse_order.each do |x|
      puts "#{x.id}, #{x.name}, #{x.due_date}, #{x.completed}"
    end
    end
      # show
            # find or create the right todo list
            # show the tasks ordered as requested, default to reverse order (recently entered first)


      # list_name = options[:list]
      # list_completed = options[:completed]
      # list_sort = options[:sort]
      #
      # task = Task.find_or_create_by({list_id: list.id, name: name, due_date: due_date, completed: completed})

    end





    desc "delete [LIST OR USER]", "Delete a todo list or a user."
    option :list, :aliases => :l, :default => "*default*",
      :desc => "The todo list which will be deleted (including items)."
    option :user, :aliases => :u,
      :desc => "The user which will be deleted (including lists and items)."
    def delete

      list = List.find_by(name: options[:list])
      user = User.find_by(name: options[:user])

      if list
        list = list.destroy
        if list.valid?
          puts "Great success!"
        else
          puts "Not a list.."
        end
      else user
        user = user.destroy
        if user.valid?
          puts "Great success!"
        else
          puts "Not a user.."
        end
      end
      
      # delete
            # BAIL if both list and user options are provided
            # BAIL if neither list or user option is provided
            # find the matching user or list
            # BAIL if the user or list couldn't be found
            # delete them (and any dependents)
    end

    desc "switch USER", "Switch session to manage USER's todo lists."
    def switch(username)
      user = User.find_or_create_by(name: username)
      user.sessions.create
    end

    private
    def current_user
      Session.last.user
    end
  end
end

# binding.pry
TooDone::App.start(ARGV)

#input in Thor:
# puts "ENTER SOMETHING:"
# my_variable = STDIN.gets.chomp
