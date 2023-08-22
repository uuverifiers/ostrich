(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (((\d{0,2})\(\d{3}\))|(\d{3}-))\d{3}-\d{4}\s{0,}((([Ee][xX][Tt])|([Pp][Oo][Ss][Tt][Ee])):\d{1,5}){0,1}
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 0 2) (re.range "0" "9")) (str.to_re "(") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ")")) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-"))) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.++ (re.union (re.++ (re.union (str.to_re "E") (str.to_re "e")) (re.union (str.to_re "x") (str.to_re "X")) (re.union (str.to_re "T") (str.to_re "t"))) (re.++ (re.union (str.to_re "P") (str.to_re "p")) (re.union (str.to_re "O") (str.to_re "o")) (re.union (str.to_re "S") (str.to_re "s")) (re.union (str.to_re "T") (str.to_re "t")) (re.union (str.to_re "E") (str.to_re "e")))) (str.to_re ":") ((_ re.loop 1 5) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; ^(\d{4}[- ]){3}\d{4}|\d{16}$
(assert (not (str.in_re X (re.union (re.++ ((_ re.loop 3 3) (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.union (str.to_re "-") (str.to_re " ")))) ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ ((_ re.loop 16 16) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
; (^[a-zA-Z][a-zA-Z0-9_]*)|(^[_][a-zA-Z0-9_]+)
(assert (str.in_re X (re.union (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_")))) (re.++ (str.to_re "\u{0a}_") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_")))))))
; /\x2Fmrow\x5Fpin\x2F\x3Fid\d+[a-z]{5,}\d{5}\u{26}rnd\x3D\d+/smi
(assert (str.in_re X (re.++ (str.to_re "//mrow_pin/?id") (re.+ (re.range "0" "9")) ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "&rnd=") (re.+ (re.range "0" "9")) (str.to_re "/smi\u{0a}") ((_ re.loop 5 5) (re.range "a" "z")) (re.* (re.range "a" "z")))))
; /RegExp?\u{23}.{0,5}\u{28}\u{3f}[^\u{29}]{0,4}i.*?\u{28}\u{3f}\u{2d}[^\u{29}]{0,4}i.{0,50}\u{7c}\u{7c}/smi
(assert (str.in_re X (re.++ (str.to_re "/RegEx") (re.opt (str.to_re "p")) (str.to_re "#") ((_ re.loop 0 5) re.allchar) (str.to_re "(?") ((_ re.loop 0 4) (re.comp (str.to_re ")"))) (str.to_re "i") (re.* re.allchar) (str.to_re "(?-") ((_ re.loop 0 4) (re.comp (str.to_re ")"))) (str.to_re "i") ((_ re.loop 0 50) re.allchar) (str.to_re "||/smi\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
