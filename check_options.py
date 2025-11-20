from quiz.models import Question

questions = Question.objects.all()
for q in questions:
    print(f'ID: {q.id}')
    print(f'Type: {q.type}')
    print(f'Options: {q.options}')
    print(f'Correct Answer: {q.correct_answer}')
    print(f'Options Type: {type(q.options)}')
    print(f'Has A option: "A" in q.options: {"A" in q.options}')
    print('-' * 50)