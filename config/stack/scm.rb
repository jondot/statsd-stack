package :git, :provides => :scm do
  description 'Git Distributed Version Control'
  apt 'git-core'
  requires :git_dependencies
  
  verify do
    has_file '/usr/bin/git'
  end
end

package :git_dependencies do
  description 'Git Build Dependencies'
  apt 'git-core', :dependencies_only => true
end
