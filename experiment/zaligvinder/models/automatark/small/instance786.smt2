(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename\s*=\s*[^\r\n]*?\u{2e}pcx[\u{22}\u{27}\u{3b}\s\r\n]/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re ".pcx") (re.union (str.to_re "\u{22}") (str.to_re "'") (str.to_re ";") (str.to_re "\u{0d}") (str.to_re "\u{0a}") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "/i\u{0a}")))))
; ((\+351|00351|351)?)(2\d{1}|(9(3|6|2|1)))\d{7}
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "+351") (str.to_re "00351") (str.to_re "351"))) (re.union (re.++ (str.to_re "2") ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ (str.to_re "9") (re.union (str.to_re "3") (str.to_re "6") (str.to_re "2") (str.to_re "1")))) ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; offers\x2Ebullseye-network\x2Ecom[^\n\r]*this\dwww\x2Etrustedsearch\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "offers.bullseye-network.com") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "this") (re.range "0" "9") (str.to_re "www.trustedsearch.com\u{0a}"))))
; ^[\d]{5}[-\s]{1}[\d]{4}[-\s]{1}[\d]{2}$
(assert (not (str.in_re X (re.++ ((_ re.loop 5 5) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^[1-9][0-9]{1,6}\-[0-9]{2}\-[0-9]
(assert (not (str.in_re X (re.++ (re.range "1" "9") ((_ re.loop 1 6) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") (re.range "0" "9") (str.to_re "\u{0a}")))))
(check-sat)
