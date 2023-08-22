(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; select\x2FGet\s+Host\x3A.*ppcdomain\x2Eco\x2Euk
(assert (not (str.in_re X (re.++ (str.to_re "select/Get") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.* re.allchar) (str.to_re "ppcdomain.co.uk\u{0a}")))))
; User-Agent\u{3a}\sRequestwww\x2Ealtnet\x2EcomSubject\x3A
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Requestwww.altnet.com\u{1b}Subject:\u{0a}")))))
; ookflolfctm\u{2f}nmot\.fmu
(assert (not (str.in_re X (str.to_re "ookflolfctm/nmot.fmu\u{0a}"))))
; ^((\d{3}[- ]\d{3}[- ]\d{2}[- ]\d{2})|(\d{3}[- ]\d{2}[- ]\d{2}[- ]\d{3}))$
(assert (not (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re "-") (str.to_re " ")) ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re "-") (str.to_re " ")) ((_ re.loop 2 2) (re.range "0" "9")) (re.union (str.to_re "-") (str.to_re " ")) ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re "-") (str.to_re " ")) ((_ re.loop 2 2) (re.range "0" "9")) (re.union (str.to_re "-") (str.to_re " ")) ((_ re.loop 2 2) (re.range "0" "9")) (re.union (str.to_re "-") (str.to_re " ")) ((_ re.loop 3 3) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; Host\x3AFrom\u{3a}User-Agent\x3A\x2Fr\x2Fkeys\x2FkeysClient
(assert (str.in_re X (str.to_re "Host:From:User-Agent:/r/keys/keysClient\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
