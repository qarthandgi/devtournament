export function sandboxInit (db) {
  return {
    name: 'SANDBOX',
    database: db.toUpperCase(),
    objective: 'Hone your skills to prepare for the exercises.',
    requirements: []
  }
}

export function tableData () {
  return {
    headers: [],
    rows: []
  }
}

export function blankOutputRequirement () {
  return {
    column: '',
    description: ''
  }
}
