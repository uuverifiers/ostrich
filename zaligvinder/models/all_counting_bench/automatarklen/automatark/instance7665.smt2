(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((A(((H[MX])|(M(P|SN))|(X((D[ACH])|(M[DS]))?)))?)|(K7(A)?)|(D(H[DLM])?))(\d{3,4})[ABD-G][CHJK-NPQT-Y][Q-TV][1-4][B-E]$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "A") (re.opt (re.union (re.++ (str.to_re "H") (re.union (str.to_re "M") (str.to_re "X"))) (re.++ (str.to_re "M") (re.union (str.to_re "P") (str.to_re "SN"))) (re.++ (str.to_re "X") (re.opt (re.union (re.++ (str.to_re "D") (re.union (str.to_re "A") (str.to_re "C") (str.to_re "H"))) (re.++ (str.to_re "M") (re.union (str.to_re "D") (str.to_re "S"))))))))) (re.++ (str.to_re "K7") (re.opt (str.to_re "A"))) (re.++ (str.to_re "D") (re.opt (re.++ (str.to_re "H") (re.union (str.to_re "D") (str.to_re "L") (str.to_re "M")))))) ((_ re.loop 3 4) (re.range "0" "9")) (re.union (str.to_re "A") (str.to_re "B") (re.range "D" "G")) (re.union (str.to_re "C") (str.to_re "H") (str.to_re "J") (re.range "K" "N") (str.to_re "P") (str.to_re "Q") (re.range "T" "Y")) (re.union (re.range "Q" "T") (str.to_re "V")) (re.range "1" "4") (re.range "B" "E") (str.to_re "\u{0a}")))))
; ^((\+989)|(989)|(00989)|(09|9))([1|2|3][0-9]\d{7}$)
(assert (str.in_re X (re.++ (re.union (str.to_re "+989") (str.to_re "989") (str.to_re "00989") (str.to_re "09") (str.to_re "9")) (str.to_re "\u{0a}") (re.union (str.to_re "1") (str.to_re "|") (str.to_re "2") (str.to_re "3")) (re.range "0" "9") ((_ re.loop 7 7) (re.range "0" "9")))))
; /\u{2e}smi([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.smi") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; ixqshv\u{2f}qzccsMM_RECO\x2EEXE%3fwwwwp-includes\x2Ftheme\x2Ephp\x3F
(assert (str.in_re X (str.to_re "ixqshv/qzccsMM_RECO.EXE%3fwwwwp-includes/theme.php?\u{0a}")))
; /RegExp?\u{23}.{0,5}\u{28}\u{3f}[^\u{29}]{0,4}i.*?\u{28}\u{3f}\u{2d}[^\u{29}]{0,4}i.{0,50}\u{7c}\u{7c}/smi
(assert (not (str.in_re X (re.++ (str.to_re "/RegEx") (re.opt (str.to_re "p")) (str.to_re "#") ((_ re.loop 0 5) re.allchar) (str.to_re "(?") ((_ re.loop 0 4) (re.comp (str.to_re ")"))) (str.to_re "i") (re.* re.allchar) (str.to_re "(?-") ((_ re.loop 0 4) (re.comp (str.to_re ")"))) (str.to_re "i") ((_ re.loop 0 50) re.allchar) (str.to_re "||/smi\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
