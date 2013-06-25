Code.require_file "../test_helper.exs", __DIR__

defmodule MocksTest do
  use Amrita.Sweet
  use Amrita.Mocks

  import Support

  defmodule Polite do
    def swear? do
      false
    end

    def message do
      "oh swizzlesticks"
    end
  end

  fact "check unstubbed module was preserved after stub" do
    Polite.swear? |> falsey
    Polite.message |> "oh swizzlesticks"
  end

  fact "simple mock on existing module" do
    provided [MocksTest.Polite.swear? |> true] do
      Polite.swear? |> truthy
    end
  end

  failing_fact "provided when not called raises a fail" do
    provided [MocksTest.Polite.swear? |> true] do
      Polite.message |> "oh swizzlesticks"
    end
  end

  fact "check again that unstubbed module was preserved after stub" do
    Polite.swear? |> falsey
    Polite.message |> "oh swizzlesticks"
  end

  fact "multi mocks on same module" do
    provided [MocksTest.Polite.swear? |> true,
              MocksTest.Polite.message |> "funk"] do
      Polite.swear? |> truthy
      Polite.message |> "funk"
    end
  end

  defmodule Rude do
    def swear? do
      true
    end
  end

  fact "multi mocks on different modules" do
    provided [MocksTest.Polite.swear? |> true,
              MocksTest.Rude.swear? |> false] do
      Polite.swear? |> truthy
      Rude.swear? |> falsey
    end
  end

  defmodule Funk do
    def hip?(_arg) do
      true
    end
  end

  fact "mock with an argument" do
    provided [MocksTest.Funk.hip?(:yes) |> false] do
      Funk.hip?(:yes) |> falsey
    end
  end

  failing_fact "mock with an argument that does not match fails" do
    provided [MocksTest.Funk.hip?(:yes) |> false] do
      Funk.hip?(:no) |> falsey
    end
  end

  fact "mock with a wildcard" do
    provided [MocksTest.Funk.hip?(:_) |> false] do
      Funk.hip?(:yes) |> falsey
      Funk.hip?(:whatever) |> falsey
    end
  end

  fact "mock anything wildcard" do
    provided [MocksTest.Funk.hip?(anything, anything, anything) |> false] do
      Funk.hip?(:yes, :no, :maybe) |> falsey
    end
  end

  failing_fact "failing anything wildcard" do
    provided [MocksTest.Funk.hip?(anything, anything, anything) |> false] do
      Funk.hip?(:yes, :no, :maybe, :funk) |> falsey
    end
  end

  fact "mock with many arguments" do
    provided [MocksTest.Funk.flop?(:yes, :no, :yes) |> false] do
      Funk.flop?(:yes, :no, :yes) |> falsey
    end
  end

  failing_fact "mock with a mismatch in arity of arguments fails" do
    provided [MocksTest.Funk.hip?(:yes) |> false] do
      Funk.hip?(:yes, :no) |> falsey
    end
  end

  fact "mock with > 6 arguments" do
    provided [MocksTest.Funk.flop?(:a, :b, :c, :d, :e, :f, :g, :h) |> false] do
      Funk.flop?(:a, :b, :c, :d, :e, :f, :g, :h) |> falsey
    end
  end

end
