(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(([0-1]?[0-9])|([2][0-3])):([0-5]?[0-9])(:([0-5]?[0-9]))?$
(assert (str.in_re X (re.++ (re.union (re.++ (re.opt (re.range "0" "1")) (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re ":") (re.opt (re.++ (str.to_re ":") (re.opt (re.range "0" "5")) (re.range "0" "9"))) (str.to_re "\u{0a}") (re.opt (re.range "0" "5")) (re.range "0" "9"))))
; 714|760|949|619|909|951|818|310|323|213|323|562|626-\d{3}-\d{4}
(assert (str.in_re X (re.union (str.to_re "714") (str.to_re "760") (str.to_re "949") (str.to_re "619") (str.to_re "909") (str.to_re "951") (str.to_re "818") (str.to_re "310") (str.to_re "323") (str.to_re "213") (str.to_re "323") (str.to_re "562") (re.++ (str.to_re "626-") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /[^\u{20}-\u{7e}\u{0d}\u{0a}]{4}/P
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 4 4) (re.union (re.range " " "~") (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "/P\u{0a}"))))
; /^resolve\u{7c}\d+\u{7c}\d+\x7C[a-z0-9]+\x2E[a-z]{2,3}\x7C[a-z0-9]+\x7C/
(assert (str.in_re X (re.++ (str.to_re "/resolve|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".") ((_ re.loop 2 3) (re.range "a" "z")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "|/\u{0a}"))))
; /User-Agent\u{3a}\sMSIE.*\u{3b}\sNT.*\u{3b}\sAV.*\u{3b}\sOV.*\u{3b}\sNA.*VR\u{28}PH5.0\sW20130912/H
(assert (not (str.in_re X (re.++ (str.to_re "/User-Agent:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "MSIE") (re.* re.allchar) (str.to_re ";") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "NT") (re.* re.allchar) (str.to_re ";") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "AV") (re.* re.allchar) (str.to_re ";") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "OV") (re.* re.allchar) (str.to_re ";") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "NA") (re.* re.allchar) (str.to_re "VR(PH5") re.allchar (str.to_re "0") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "W20130912/H\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
