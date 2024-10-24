import pandas as pd
import os
import time
from datetime import datetime
from collections import Counter

# Function to load and shuffle the CSV data
def load_and_shuffle_data(file_path):
    try:
        # Read the CSV file into a DataFrame
        df = pd.read_csv(file_path)
        
        # Shuffle the DataFrame rows randomly
        df = df.sample(frac=1, random_state=None).reset_index(drop=True)
        return df
    except FileNotFoundError:
        # Handle the case where the file is not found
        print("CSV file not found.")
        exit()
    except Exception as e:
        # Catch and print any other exceptions that occur
        print(f"An error occurred: {e}")
        exit()

# Function to display the question and options to the user
def display_question(snf_id, chapter, question_id, question, options):
    # Clear the console screen (works for both Windows and Unix)
    os.system('cls' if os.name == 'nt' else 'clear')
    print(f"""
########### Instructions ##########################################
###################################################################
##### Type valid keys [A-E], no spaces, more than one allowed.
##### Alphabetical order ('ABC', not 'CBA').
###################################################################

From {chapter}
{question_id}. {question}
""")
    # Display each option with a corresponding letter
    for idx, option in enumerate(options, start=65):  # ASCII code for 'A' is 65
        print(f"    {chr(idx)}. {option}")

# Function to get a valid response from the user
def get_response():
    valid_responses = set('ABCDE')
    while True:
        response = input("\nType your answer: ").strip().upper()
        # Ensure the response only contains valid letters and is not empty
        if not response or not all(char in valid_responses for char in response):
            print("Invalid input. Please enter letters A-E.")
            time.sleep(2)
        else:
            return response

# Function to evaluate responses from the user
def evaluate_responses(df):
    # Initialize a dictionary to store results
    dataset_results = {
        'snf_id': [],
        'snf_user_response': [],
        'snf_answ_description': [],
        'snf_correct_combo': [],
        'snf_validator': [],
        'snf_time_response': []
    }

    # Iterate over each row in the DataFrame
    for _, row in df.iterrows():
        # Extract options for the current question
        options = [row[f'SNF_{col}_COL'] for col in 'ABCDE' if pd.notna(row[f'SNF_{col}_COL'])]
        
        # Display the question to the user
        display_question(row['SNF_ID'], row['SNF_CHAPTER'], row['SNF_REVIEW_QUESTIONS_ID'], row['SNF_REVIEW_QUESTIONS'], options)
        
        # Get the user's response
        response = get_response()
        is_correct = response == row['SNF_CORRECT_COMBO']
        
        # Record data for later analysis or output
        dataset_results['snf_id'].append(row['SNF_ID'])
        dataset_results['snf_user_response'].append(response)
        dataset_results['snf_correct_combo'].append(row['SNF_CORRECT_COMBO'])
        dataset_results['snf_answ_description'].append(row['SNF_ANSWER_DESCRIPTIONS'])
        dataset_results['snf_validator'].append('Correct' if is_correct else 'Wrong')
        dataset_results['snf_time_response'].append(datetime.now())
        
        # Provide feedback to the user with detailed explanation
        description = row['SNF_ANSWER_DESCRIPTIONS']
        if is_correct:
            print("\nCorrect answer! More details:")
        else:
            print("\nIncorrect answer. More details:")
            print(f"The correct combo is {row['SNF_CORRECT_COMBO']}")
        print(f"\n{description}")
        input("\nPress any key to continue...")

    return dataset_results

# Main function to run the program
def main():
    start_exam_time = datetime.now()  # Record the start time of the quiz
    df = load_and_shuffle_data('SNF_certif_exam_db.csv')  # Load and shuffle the data
    results = evaluate_responses(df)  # Evaluate user responses
    
    # Save results to a CSV file
    output_file = "result_file.csv"
    pd.DataFrame(results).to_csv(output_file)
    
    # Calculate and display performance summary and total time taken
    right_wrong_counter = Counter(results['snf_validator'])
    total_time = datetime.now() - start_exam_time
    print(f"""
    Thanks so much for participating.
    Your results are in the file: {output_file}
    
    Performance Summary: {right_wrong_counter}
    Total duration of attempt: {total_time}
    
    Good luck on your exam!!!
    """)
    input("\nPress enter to exit.")

if __name__ == "__main__":
    main()

