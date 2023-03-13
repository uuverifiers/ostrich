(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \d{2}\s?[A-Z]{1,3}\s?\d{2,4}
(assert (not (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 1 3) (re.range "A" "Z")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; Subject\u{3a}Porta\x2Fasp\x2Foffers\.asp\?\x2Fiis2ebs\.aspwww\x2Esmileycentral\x2Ecom
(assert (not (str.in_re X (str.to_re "Subject:Porta/asp/offers.asp?/iis2ebs.aspwww.smileycentral.com\u{0a}"))))
; ^[A-Z]\d{2}(\.\d){0,1}$
(assert (str.in_re X (re.++ (re.range "A" "Z") ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
(check-sat)
