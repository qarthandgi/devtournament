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
    rows: [],
    error: false,
    errorMessage: ''
  }
}

export function blankOutputRequirement () {
  return {
    column: '',
    description: ''
  }
}
