# encoding: utf-8
module Enumerable

  # Sum of all elements in Array
  def sum
    self.reduce(:+)
  end
  # Mean of elements in Array
  def mean
    self.sum/self.length.to_f
  end

  # Variance of elements in Array
  def sample_variance
    mean = self.mean
    sum = self.inject(0) do |accum, index|
      accum + (index - mean) ** 2
    end
    sum/(self.length - 1).to_f
  end

  # Standard Deviation of elements in Array
  def standard_deviation
    return Math.sqrt(self.sample_variance)
  end

end