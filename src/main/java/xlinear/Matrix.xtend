package xlinear

import java.util.stream.DoubleStream

/**
 * Note: it is not recommended that the user implements this interface
 *   directly, since many operators depend on more detailed knowledge of 
 *   the implementation for efficiency, in particular if the matrix is dense
 *   or sparse. So we assume at many places a finite number of direct sub-classes 
 *   of this interface.
 * 
 * TODO: add instructions on how to sub-class, by using DenseMatrix or SparseMatrix
 */
interface Matrix { 
  
  def Matrix slice(int row0Incl, int row1Excl, int col0Incl, int col1Excl, boolean makeReadOnly) 
  
  def Matrix slice(int row0Incl, int row1Excl, int col0Incl, int col1Excl) {
    return slice(row0Incl, row1Excl, col0Incl, col1Excl, false)
  }
  def Matrix row(int index) {
    return slice(index, index + 1, 0, nCols, false)
  }
  def Matrix col(int index) {
    return slice(0, nRows, index, index + 1, false)
  }
  def Matrix readOnlyView() {
    return slice(0, nRows, 0, nCols, true)
  }
  
  def int nRows()
  def int nCols()
  def int nEntries() {
    return nRows() * nCols()
  }

  def double get(int row, int col)
  def void set(int row, int col, double v)
  
  def DoubleStream nonZeroEntries()
  
  /**
   * If this matrix is a vector (either n by 1, or 1 by n),
   * return the value at given index, otherwise, throw 
   * the StaticUtils::notAVectorException exception.
   */
  def double get(int index) {
    if (!isVector()) 
      throw StaticUtils::notAVectorException
    if (nRows() == 1)
      return get(0, index)
    else
      return get(index, 0)
  }
  
  def void set(int index, double value) {
    if (!isVector()) 
      throw StaticUtils::notAVectorException
    if (nRows() == 1)
      set(0, index, value)
    else
      set(index, 0, value)
  }
  
  def boolean isVector() {
    return nRows() == 1 || nCols() == 1
  }
  
  def Matrix createEmpty(int nRows, int nCols)
  
  def CholeskyDecomposition cholesky()
  def LUDecomposition lu()
  def Matrix transpose()
  def Matrix inverse()
  
  //// scalar * or /
  
  def Matrix *(Number n)
  def Matrix mul(Number n)
  
  def Matrix /(Number n) { div(n) }
  def Matrix div(Number n) {
    return mul(1.0/n)
  }
  
  
  //// scalar *=
  
  def void *=(Number n) { mulInPlace(n) }
  def void mulInPlace(Number n)
  
  def void /=(Number n) { divInPlace(n) }
  def void divInPlace(Number n) {
    mulInPlace(1.0/n)
  }
  
  //// matrix *
  
  def Matrix *(Matrix m)
  def DenseMatrix *(DenseMatrix m)
  def Matrix *(SparseMatrix m)
  
  def Matrix mul(Matrix m) {
    switch m {
      SparseMatrix  : return mul(m)
      DenseMatrix   : return mul(m)
      default :
        throw StaticUtils::denseOrSparseException
    }
  }
  def DenseMatrix mul(DenseMatrix m)
  def Matrix mul(SparseMatrix m)
  
  
  //// matrix *= : not supported as efficient implementations used here typically 
  ////             need an extra matrix anyways
  
  //// +
  
  def Matrix +(Matrix m)         
  def DenseMatrix +(DenseMatrix m)  
  def Matrix +(SparseMatrix m) 
  
  def Matrix add(Matrix m) {
    switch m {
      SparseMatrix : return add(m)
      DenseMatrix  : return add(m)
      default :
        throw StaticUtils::denseOrSparseException
    }
  }
  def DenseMatrix add(DenseMatrix m)
  def Matrix add(SparseMatrix m)
  
  //// +=
  
  def void +=(Matrix m)       { addInPlace(m) }
  def void +=(DenseMatrix m)  { addInPlace(m) }
  def void +=(SparseMatrix m) { addInPlace(m) }
  
  def void addInPlace(Matrix m) {
    switch m {
      DenseMatrix  : addInPlace(m)
      SparseMatrix : addInPlace(m)
      default :
        throw StaticUtils::denseOrSparseException
    }
  }
  def void addInPlace(DenseMatrix m)
  def void addInPlace(SparseMatrix m)
  
  //// -
  
  def Matrix -(Matrix m)         
  def DenseMatrix -(DenseMatrix m)  
  def Matrix -(SparseMatrix m) 
  
  def Matrix sub(Matrix m) {
    switch m {
      SparseMatrix : return sub(m)
      DenseMatrix  : return sub(m)
      default :
        throw StaticUtils::denseOrSparseException
    }
  }
  def DenseMatrix sub(DenseMatrix m)
  def Matrix sub(SparseMatrix m)
  
  
  //// -=
  
  def void -=(Matrix m)       { subInPlace(m) }
  def void -=(DenseMatrix m)  { subInPlace(m) }
  def void -=(SparseMatrix m) { subInPlace(m) }
  
  def void subInPlace(Matrix m) {
    switch m {
      DenseMatrix  : subInPlace(m)
      SparseMatrix : subInPlace(m)
      default :
        throw StaticUtils::denseOrSparseException
    }
  }
  def void subInPlace(DenseMatrix m)
  def void subInPlace(SparseMatrix m)
  
  // TODO: offer implementations of equals, hashcode (use visitSkipSomeZeros? which you may want to add here in interface, or not needed actually)
  // TODO: same for toString, with options to limit # of entries
  
}

