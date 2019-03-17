# This file should contain all the record creation needed to seed the database
# with its default values.
# The data can then be loaded with the rails db:seed command (or created
# alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lala land' }])
#   Character.create(name: 'Luke', movie: movies.first)

ahmed = Admin.create(
  first_name: 'Ahmed',
  last_name: 'Elsayed',
  city: 'Alexandria',
  country: 'Egypt',
  date_of_birth: '1984-03-20',
  email: 'ahmed@egsl.com',
  gender: 'male',
  password: 'password',
  password_confirmation: 'password'
)
ahmed.confirm

youssef = User.create(
  first_name: 'Youssef',
  last_name: 'Fares',
  city: 'Alexandria',
  country: 'Egypt',
  date_of_birth: '1996-03-17',
  email: 'youssef@egsl.com',
  gender: 'male',
  password: 'password',
  password_confirmation: 'password'
)
youssef.confirm

yara = Reviewer.create(
  first_name: 'Yara',
  last_name: 'Abdullatif',
  city: 'Alexandria',
  country: 'Egypt',
  date_of_birth: '1996-03-18',
  email: 'yara@egsl.com',
  gender: 'female',
  password: 'password',
  password_confirmation: 'password'
)
yara.confirm

tarek = User.create(
  first_name: 'Tarek',
  last_name: 'Alqady',
  city: 'Alexandria',
  country: 'Egypt',
  date_of_birth: '1996-03-18',
  email: 'tarek@egsl.com',
  gender: 'male',
  password: 'password',
  password_confirmation: 'password'
)
tarek.confirm

Category.create(
  [
    { name: 'أفعال' }, { name: 'اﻷسرة' }, { name: 'أُخرى' }, { name: 'أيام' },
    { name: 'ألوان' }, { name: 'مأكولات' }, { name: 'حيوانات' },
    { name: 'حروف جر' }
  ]
)

Word.create(
  [
    { name: 'يمشي', part_of_speech: 'فعل',
      categories: [Category.find_by(name: 'أفعال')] },

    { name: 'أب', part_of_speech: 'اسم',
      categories: [Category.find_by(name: 'اﻷسرة')] },

    { name: 'أم', part_of_speech: 'اسم',
      categories: [Category.find_by(name: 'اﻷسرة')] },

    { name: 'أحمر', part_of_speech: 'اسم',
      categories: [Category.find_by(name: 'ألوان')] },

    { name: 'أسود', part_of_speech: 'اسم',
      categories: [Category.find_by(name: 'ألوان')] },

    { name: 'سمكة', part_of_speech: 'اسم',
      categories: Category.where(name: %w[مأكولات حيوانات]) },

    { name: 'على', part_of_speech: 'حرف',
      categories: [Category.find_by(name: 'حروف جر')] }
  ]
)

# path variable for current directory
path = File.join Rails.root, 'db'

red = Gesture.create(
  user: User.find_by(uid: 'tarek@egsl.com'),
  word: Word.find_by(name: 'أحمر'),
  primary_dictionary_gesture: true
)
red.video.attach(
  io: File.open(File.join(path, 'أحمر.mp4')),
  filename: 'أحمر.mp4'
)

saturday = Gesture.create(
  user: User.find_by(uid: 'tarek@egsl.com'),
  word: Word.find_by(name: 'السبت')
)
saturday.video.attach(
  io: File.open(File.join(path, 'السبت.mp4')),
  filename: 'السبت.mp4'
)

Review.create(
  reviewer: yara,
  gesture: saturday,
  accepted: false,
  comment: 'Tarek is too cute.'
)
