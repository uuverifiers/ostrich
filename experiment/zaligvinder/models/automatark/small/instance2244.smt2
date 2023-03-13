(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d{10}$
(assert (not (str.in_re X (re.++ ((_ re.loop 10 10) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /^\u{2f}rouji.txt$/mU
(assert (not (str.in_re X (re.++ (str.to_re "//rouji") re.allchar (str.to_re "txt/mU\u{0a}")))))
; [^a-zA-Z \-]|(  )|(\-\-)|(^\s*$)
(assert (str.in_re X (re.union (str.to_re "  ") (str.to_re "--") (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}")) (re.range "a" "z") (re.range "A" "Z") (str.to_re " ") (str.to_re "-"))))
; User-Agent\x3A\d+moreKontikiHost\u{3a}
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.range "0" "9")) (str.to_re "moreKontikiHost:\u{0a}")))))
(check-sat)
