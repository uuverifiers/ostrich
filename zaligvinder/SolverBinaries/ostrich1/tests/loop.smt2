(declare-fun TestC0 () String)
(declare-fun |1 Fill 2| () String)
(declare-fun |1 Fill 0| () String)
(declare-fun |1 Fill 1| () String)
(declare-fun |1 Fill 3| () String)
(assert (str.in.re TestC0
           (re.++ (re.* (re.range "\x00" "\xff"))
                  ((_ re.loop 3 3) (re.range "0" "9"))
                  (re.* (re.range "0" "9"))
                  (re.* (re.range "\x00" "\xff")))))
(assert (let ((a!1 (str.in.re TestC0
                      (re.++ (re.* (re.range "\x00" "\xff"))
                             ((_ re.^ 3) (re.range "0" "9"))
                             (re.* (re.range "0" "9"))
                             (re.* (re.range "\x00" "\xff"))))))
  (=> a!1 (= TestC0 (str.++ |1 Fill 1| "" "" |1 Fill 0| |1 Fill 2|)))))
(assert (str.in.re |1 Fill 0|
           (re.++ ((_ re.loop 3 3) (re.range "0" "9"))
                  (re.* (re.range "0" "9")))))
(assert (str.in.re (str.++ "" "" |1 Fill 0|)
           (re.++ ((_ re.loop 3 3) (re.range "0" "9"))
                  (re.* (re.range "0" "9")))))
(assert (= |1 Fill 3| (str.++ "" "" |1 Fill 0|)))

(check-sat)

