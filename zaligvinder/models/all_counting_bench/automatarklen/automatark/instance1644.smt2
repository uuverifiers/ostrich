(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \b(((20)((0[0-9])|(1[0-1])))|(([1][^0-8])?\d{2}))((0[1-9])|1[0-2])((0[1-9])|(2[0-9])|(3[01]))[-+]?\d{4}[,.]?\b
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "20") (re.union (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "1")))) (re.++ (re.opt (re.++ (str.to_re "1") (re.range "0" "8"))) ((_ re.loop 2 2) (re.range "0" "9")))) (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1")))) (re.opt (re.union (str.to_re "-") (str.to_re "+"))) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.union (str.to_re ",") (str.to_re "."))) (str.to_re "\u{0a}")))))
; ^[\+\-]?\d+(,\d+)?$
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.+ (re.range "0" "9")) (re.opt (re.++ (str.to_re ",") (re.+ (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; www\x2Emakemesearch\x2EcomLOGOnevclxatmlhavj\u{2f}vsy
(assert (not (str.in_re X (str.to_re "www.makemesearch.comLOGOnevclxatmlhavj/vsy\u{0a}"))))
; /filename=[\u{22}\u{27}]?[^\n]*\u{2e}gni[\u{22}\u{27}\s]/si
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.opt (re.union (str.to_re "\u{22}") (str.to_re "'"))) (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".gni") (re.union (str.to_re "\u{22}") (str.to_re "'") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "/si\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
