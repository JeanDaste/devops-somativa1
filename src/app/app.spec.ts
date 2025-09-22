import { TestBed, ComponentFixture } from '@angular/core/testing';
import { App } from './app';

describe('App', () => {
  let fixture: ComponentFixture<App>;
  let app: App;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [App],
    }).compileComponents();

    fixture = TestBed.createComponent(App);
    app = fixture.componentInstance;
  });
  it('deve criar a aplicação com sucesso', () => {
    expect(app).toBeTruthy();
  });

  it('deve ter o sinal "title" com o valor inicial "my-first-angular"', () => {
    expect(app['title']()).toEqual('my-first-angular');
  });

  it('deve renderizar o formulário de pesquisa (survey-form)', () => {
    fixture.detectChanges();
    const compiled = fixture.nativeElement as HTMLElement;
    expect(compiled.querySelector('#survey-form')).not.toBeNull();
  });

  it('deve exibir o título fixo "First Survey Form" na tag h1', () => {
    fixture.detectChanges();
    const compiled = fixture.nativeElement as HTMLElement;
    const h1 = compiled.querySelector('h1');
    expect(h1?.textContent).toEqual('First Survey Form');
  });

  it('deve permitir a alteração do valor do signal "title" na classe', () => {
    expect(app['title']()).toEqual('my-first-angular');

    app['title'].set('novo titulo');

    expect(app['title']()).toEqual('novo titulo');
  });

});