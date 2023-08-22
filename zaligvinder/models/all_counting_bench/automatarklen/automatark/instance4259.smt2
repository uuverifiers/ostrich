(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(([8]))$|^((([0-7]))$|^((([0-7])).?((25)|(50)|(5)|(75)|(0)|(00))))$
(assert (not (str.in_re X (re.union (str.to_re "8") (re.++ (re.union (re.range "0" "7") (re.++ (re.range "0" "7") (re.opt re.allchar) (re.union (str.to_re "25") (str.to_re "50") (str.to_re "5") (str.to_re "75") (str.to_re "0") (str.to_re "00")))) (str.to_re "\u{0a}"))))))
; ^[0-9]+([\,|\.]{0,1}[0-9]{2}){0,1}$
(assert (str.in_re X (re.++ (re.+ (re.range "0" "9")) (re.opt (re.++ (re.opt (re.union (str.to_re ",") (str.to_re "|") (str.to_re "."))) ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; CH\d{2}[ ]\d{4}[ ]\d{4}[ ]\d{4}[ ]\d{4}[ ]\d{1}|CH\d{19}
(assert (not (str.in_re X (re.++ (str.to_re "CH") (re.union (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ ((_ re.loop 19 19) (re.range "0" "9")) (str.to_re "\u{0a}")))))))
; pjpoptwql\u{2f}rlnj\sPG=SPEEDBARadblock\x2Elinkz\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "pjpoptwql/rlnj") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "PG=SPEEDBARadblock.linkz.com\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
