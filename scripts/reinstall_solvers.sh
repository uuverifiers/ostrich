WORKD_DIR=/opt
BINARY_DIR=$WORKD_DIR/zaligvinder/SolverBinaries

# Clean the solvers binary directory
rm -rf $BINARY_DIR && mkdir -p $BINARY_DIR

# Install OSTRICH2
cd $WORKD_DIR && mkdir ostrich2 && cd ostrich2 &&
  git clone https://github.com/uuverifiers/ostrich.git &&
  cd ostrich &&
  git checkout 0a58d0c &&
  sbt assembly &&
  mkdir -p $BINARY_DIR/ostrich2/target &&
  cp target/scala-* $BINARY_DIR/ostrich2/target -r &&
  cp ostrich $BINARY_DIR/ostrich2/ &&
  rm -rf $WORKD_DIR/ostrich2

# Install OSTRICH1.3 (old version)
cd $WORKD_DIR && mkdir ostrich1 && cd ostrich1 &&
  wget https://github.com/uuverifiers/ostrich/releases/download/v1.3/ostrich-bin-1.3.zip &&
  unzip ostrich-bin-1.3.zip &&
  mkdir -p $BINARY_DIR/ostrich1 &&
  cp ostrich-bin-1.3/* $BINARY_DIR/ostrich1/ -r &&
  rm -rf $WORKD_DIR/ostrich1

# Install CVC5
cd $WORKD_DIR && mkdir cvc5 && cd cvc5 &&
wget https://github.com/cvc5/cvc5/releases/download/cvc5-1.2.1/cvc5-Linux-x86_64-static.zip &&
  unzip cvc5-Linux-x86_64-static.zip &&
  mkdir -p $BINARY_DIR/cvc5 &&
  cp cvc5-Linux-x86_64-static/bin/cvc5 $BINARY_DIR/cvc5/cvc5 &&
  chmod +x $BINARY_DIR/cvc5/cvc5 &&
  rm -rf $WORKD_DIR/cvc5

# Install Z3
cd $WORKD_DIR && mkdir z3 && cd z3 &&
wget https://github.com/Z3Prover/z3/archive/refs/tags/z3-4.14.1.zip &&
  unzip z3-4.14.1.zip &&
  cd z3-z3-4.14.1 &&
  python scripts/mk_make.py &&
  cd build &&
  make -j$(nproc) &&
  mkdir -p $BINARY_DIR/z3 &&
  cp z3 $BINARY_DIR/z3/ &&
  rm -rf $WORKD_DIR/z3

# Install mata (dependency for z3-noodler)
cd $WORKD_DIR && mkdir mata && cd mata &&
wget https://github.com/VeriFIT/mata/archive/refs/tags/1.6.9.zip &&
  unzip 1.6.9.zip &&
  cd mata-1.6.9 &&
  make release &&
  make install &&
  rm -rf $WORKD_DIR/mata

# Install Z3-noodler (with specific commit)
cd $WORKD_DIR && mkdir z3-noodler && cd z3-noodler &&
wget https://github.com/VeriFIT/z3-noodler/archive/refs/tags/v1.3.0.zip &&
  unzip v1.3.0.zip &&
  cd z3-noodler-1.3.0 &&
  mkdir build &&
  cd build &&
  cmake -DCMAKE_BUILD_TYPE=Release .. &&
  make -j$(nproc) &&
  mkdir -p $BINARY_DIR/z3-noodler &&
  cp z3 $BINARY_DIR/z3-noodler/ &&
  rm -rf $WORKD_DIR/z3-noodler

# Install Z3-alpha
cd $WORKD_DIR && mkdir z3alpha && cd z3alpha &&
git clone https://github.com/JohnLyu2/z3alpha.git &&
  cd z3alpha &&
  git checkout 35501f3 &&
  mkdir -p $BINARY_DIR/z3alpha &&
  cp smtcomp24/* $BINARY_DIR/z3alpha/ -r &&
  rm -rf $WORKD_DIR/z3alpha
