names = Dwek::Form.new('names')
names << { subject_id: '1', first_name: 'Kevin', last_name: 'Deisz' }
names << { subject_id: '2', first_name: 'Ezra', last_name: 'Freedman' }

occupations = Dwek::Form.new('roles')
occupations << { subject_id: '2', title: 'Chief Technology Officer' }
