Key.__elasticsearch__.create_index! force: true
Key.__elasticsearch__.refresh_index!
Key.import
