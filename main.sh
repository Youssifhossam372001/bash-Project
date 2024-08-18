#!/bin/bash

# Function to add a new user
add_user() {
    username=$(whiptail --inputbox "Enter username:" 8 39 --title "Add User" 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        password=$(whiptail --passwordbox "Enter password for $username:" 8 39 --title "Add User" 3>&1 1>&2 2>&3)
        password_confirm=$(whiptail --passwordbox "Confirm password for $username:" 8 39 --title "Add User" 3>&1 1>&2 2>&3)
        if [ "$password" = "$password_confirm" ]; then
            sudo useradd -m -p "$(openssl passwd -1 "$password")" "$username" && whiptail --msgbox "User $username added successfully." 8 39 --title "Success"
        else
            whiptail --msgbox "Passwords do not match. User not added." 8 39 --title "Error"
        fi
    fi
}


# Function to delete a user
delete_user() {
    username=$(whiptail --inputbox "Enter username to delete:" 8 39 --title "Delete User" 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        sudo userdel "$username" && whiptail --msgbox "User $username deleted successfully." 8 39 --title "Success"
    fi
}

# Function to list all users
list_users() {
    users=$(awk -F':' '{ print $1 }' /etc/passwd)
    whiptail --scrolltext --msgbox "Users:\n$users" 20 78 --title "List Users"
}

# Function to add a new group
add_group() {
    groupname=$(whiptail --inputbox "Enter group name:" 8 39 --title "Add Group" 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        sudo groupadd "$groupname" && whiptail --msgbox "Group $groupname added successfully." 8 39 --title "Success"
    fi
}


# Function to delete a group
delete_group() {
    groupname=$(whiptail --inputbox "Enter group name to delete:" 8 39 --title "Delete Group" 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        sudo groupdel "$groupname" && whiptail --msgbox "Group $groupname deleted successfully." 8 39 --title "Success"
    fi
}

# Function to list all groups
list_groups() {
    groups=$(cut -d: -f1 /etc/group)
    whiptail --msgbox "Groups:\n$groups" 20 78 --title "List Groups"
}

# Function to disable a user
disable_user() {
    username=$(whiptail --inputbox "Enter username to disable:" 8 39 --title "Disable User" 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        sudo usermod -L "$username" && whiptail --msgbox "User $username disabled successfully." 8 39 --title "Success"
    fi
}

# Function to enable a user
enable_user() {
    username=$(whiptail --inputbox "Enter username to enable:" 8 39 --title "Enable User" 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        sudo usermod -U "$username" && whiptail --msgbox "User $username enabled successfully." 8 39 --title "Success"
    fi
}

# Function to change a user's password
change_password() {
    username=$(whiptail --inputbox "Enter username:" 8 39 --title "Change Password" 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        sudo passwd "$username"
    fi
}

# Function to display about information
about() {
    whiptail --msgbox "User Management Script\nVersion 1.0\nThis script provides a simple interface for managing users and groups on a Linux system." 10 60 --title "About"
}

# Main script loop
while true; do
    OPTION=$(whiptail --title "Main Menu" --menu "Choose an option:" 20 78 10 \
    "1" "Add User" \
    "2" "Delete User" \
    "3" "List Users" \
    "4" "Add Group" \
    "5" "Delete Group" \
    "6" "List Groups" \
    "7" "Disable User" \
    "8" "Enable User" \
    "9" "Change Password" \
    "10" "About" \
    "0" "Exit" 3>&1 1>&2 2>&3)

    exitstatus=$?
    if [ $exitstatus != 0 ]; then
        break
    fi

    case $OPTION in
        1) add_user ;;
        2) delete_user ;;
        3) list_users ;;
        4) add_group ;;
        5) delete_group ;;
        6) list_groups ;;
        7) disable_user ;;
        8) enable_user ;;
        9) change_password ;;
        10) about ;;
        0) break ;;
        *) whiptail --msgbox "Invalid option. Please try again." 8 39 --title "Error" ;;
    esac
done
