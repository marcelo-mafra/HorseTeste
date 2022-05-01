unit horse.controller.router.alunos.consts;

interface

uses
 System.Classes;

type
 TAlunosURI = class
   const
     Aluno          = '/alunos/:id';
     AlunoMatricula = '/alunos/matricula/:matricula';
     Alunos         = '/alunos';
     AlunosFoco     = '/alunos/focos/:id';
     AlunosFocoGroup = '/alunos/group/:focoid/:groupid';
 end;

implementation

end.
