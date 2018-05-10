# encoding: UTF-8

require 'slaw'

describe Slaw::ActGenerator do
  subject { Slaw::ActGenerator.new('pl') }

  def parse(rule, s)
    subject.builder.text_to_syntax_tree(s, {root: rule})
  end

  def should_parse(rule, s)
    s << "\n" unless s.end_with?("\n")
    tree = subject.builder.text_to_syntax_tree(s, {root: rule})

    if not tree
      raise Exception.new(subject.failure_reason || "Couldn't match to grammar") if tree.nil?
    else
      # count an assertion
      tree.should_not be_nil
    end
  end

  def to_xml(node, *args)
    b = ::Nokogiri::XML::Builder.new
    node.to_xml(b, *args)
    b.doc.root.to_xml(encoding: 'UTF-8')
  end

  #-------------------------------------------------------------------------------
  # Basics

  describe 'simple test' do
    it 'should handle this' do
      node = parse :body, <<EOS
DZIA¸ I

Projekt ustawy

Rozdział 7. Oznaczanie przepisów ustawy i ich systematyzacja

§ 54. Pojęcie artykułu

Podstawową jednostką redakcyjną ustawy jest artykuł.

§ 55. Ustępy

1. Każdą samodzielną myśl ujmuje się w odrębny artykuł.
2. Artykuł powinien być w miarę możliwości jednozdaniowy.
3. Jeżeli samodzielną myśl wyraża zespół zdań, dokonuje się podziału artykułu na ustępy. W ustawie określanej jako "kodeks" ustępy oznacza się paragrafami (§).
4. Podział artykułu na ustępy wprowadza się także w przypadku, gdy między zdaniami wyrażającymi samodzielne myśli występują powiązania treściowe, ale treść żadnego z nich nie jest na tyle istotna, aby wydzielić ją w odrębny artykuł.

§ 56. Części arykułu (ustępu)

1. W obrębie artykułu (ustępu) zawierającego wyliczenie wyróżnia się dwie części: wprowadzenie do wyliczenia oraz punkty. Wyliczenie może kończyć się częścią wspólną, odnoszącą się do wszystkich punktów. Po części wspólnej nie dodaje się kolejnej samodzielnej myśli; w razie potrzeby formułuje się ją w kolejnym ustępie.
2. W obrębie punktów można dokonać dalszego wyliczenia, wprowadzając litery.
3. W obrębie liter można dokonać kolejnego wyliczenia, wprowadzając tiret.
4. W obrębie tiret można dokonać kolejnego wyliczenia, wprowadzając podwójne tiret.
EOS
      to_xml(node).should == '<body>
  <paragraph id="paragraph-0">
    <content>
      <p>DZIA¸ I</p>
      <p>Projekt ustawy</p>
    </content>
  </paragraph>
  <chapter id="chapter-7">
    <num>7</num>
    <heading>Oznaczanie przepisów ustawy i ich systematyzacja</heading>
    <section id="section-54">
      <num>54.</num>
      <heading>Pojęcie artykułu</heading>
      <paragraph id="section-54.paragraph-0">
        <content>
          <p>Podstawową jednostką redakcyjną ustawy jest artykuł.</p>
        </content>
      </paragraph>
    </section>
    <section id="section-55">
      <num>55.</num>
      <heading>Ustępy</heading>
      <paragraph id="section-55.paragraph-1">
        <num>1.</num>
        <content>
          <p>Każdą samodzielną myśl ujmuje się w odrębny artykuł.</p>
        </content>
      </paragraph>
    </section>
    <section id="section-56">
      <num>56.</num>
      <heading>Części arykułu (ustępu)</heading>
      <paragraph id="section-56.paragraph-1">
        <num>1.</num>
        <content>
          <p>Każdą samodzielną myśl ujmuje się w odrębny artykuł.</p>
        </content>
      </paragraph>
    </section>
  </chapter>
</body>'
    end
  end
end
