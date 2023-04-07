(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(((([\*]{1}){1})|((\*\/){0,1}(([0-9]{1}){1}|(([1-5]{1}){1}([0-9]{1}){1}){1}))) ((([\*]{1}){1})|((\*\/){0,1}(([0-9]{1}){1}|(([1]{1}){1}([0-9]{1}){1}){1}|([2]{1}){1}([0-3]{1}){1}))) ((([\*]{1}){1})|((\*\/){0,1}(([1-9]{1}){1}|(([1-2]{1}){1}([0-9]{1}){1}){1}|([3]{1}){1}([0-1]{1}){1}))) ((([\*]{1}){1})|((\*\/){0,1}(([1-9]{1}){1}|(([1-2]{1}){1}([0-9]{1}){1}){1}|([3]{1}){1}([0-1]{1}){1}))|(jan|feb|mar|apr|may|jun|jul|aug|sep|okt|nov|dec)) ((([\*]{1}){1})|((\*\/){0,1}(([0-7]{1}){1}))|(sun|mon|tue|wed|thu|fri|sat)))$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union ((_ re.loop 1 1) ((_ re.loop 1 1) (str.to_re "*"))) (re.++ (re.opt (str.to_re "*/")) (re.union ((_ re.loop 1 1) ((_ re.loop 1 1) (re.range "0" "9"))) ((_ re.loop 1 1) (re.++ ((_ re.loop 1 1) ((_ re.loop 1 1) (re.range "1" "5"))) ((_ re.loop 1 1) ((_ re.loop 1 1) (re.range "0" "9")))))))) (str.to_re " ") (re.union ((_ re.loop 1 1) ((_ re.loop 1 1) (str.to_re "*"))) (re.++ (re.opt (str.to_re "*/")) (re.union ((_ re.loop 1 1) ((_ re.loop 1 1) (re.range "0" "9"))) ((_ re.loop 1 1) (re.++ ((_ re.loop 1 1) ((_ re.loop 1 1) (str.to_re "1"))) ((_ re.loop 1 1) ((_ re.loop 1 1) (re.range "0" "9"))))) (re.++ ((_ re.loop 1 1) ((_ re.loop 1 1) (str.to_re "2"))) ((_ re.loop 1 1) ((_ re.loop 1 1) (re.range "0" "3"))))))) (str.to_re " ") (re.union ((_ re.loop 1 1) ((_ re.loop 1 1) (str.to_re "*"))) (re.++ (re.opt (str.to_re "*/")) (re.union ((_ re.loop 1 1) ((_ re.loop 1 1) (re.range "1" "9"))) ((_ re.loop 1 1) (re.++ ((_ re.loop 1 1) ((_ re.loop 1 1) (re.range "1" "2"))) ((_ re.loop 1 1) ((_ re.loop 1 1) (re.range "0" "9"))))) (re.++ ((_ re.loop 1 1) ((_ re.loop 1 1) (str.to_re "3"))) ((_ re.loop 1 1) ((_ re.loop 1 1) (re.range "0" "1"))))))) (str.to_re " ") (re.union ((_ re.loop 1 1) ((_ re.loop 1 1) (str.to_re "*"))) (re.++ (re.opt (str.to_re "*/")) (re.union ((_ re.loop 1 1) ((_ re.loop 1 1) (re.range "1" "9"))) ((_ re.loop 1 1) (re.++ ((_ re.loop 1 1) ((_ re.loop 1 1) (re.range "1" "2"))) ((_ re.loop 1 1) ((_ re.loop 1 1) (re.range "0" "9"))))) (re.++ ((_ re.loop 1 1) ((_ re.loop 1 1) (str.to_re "3"))) ((_ re.loop 1 1) ((_ re.loop 1 1) (re.range "0" "1")))))) (str.to_re "jan") (str.to_re "feb") (str.to_re "mar") (str.to_re "apr") (str.to_re "may") (str.to_re "jun") (str.to_re "jul") (str.to_re "aug") (str.to_re "sep") (str.to_re "okt") (str.to_re "nov") (str.to_re "dec")) (str.to_re " ") (re.union ((_ re.loop 1 1) ((_ re.loop 1 1) (str.to_re "*"))) (re.++ (re.opt (str.to_re "*/")) ((_ re.loop 1 1) ((_ re.loop 1 1) (re.range "0" "7")))) (str.to_re "sun") (str.to_re "mon") (str.to_re "tue") (str.to_re "wed") (str.to_re "thu") (str.to_re "fri") (str.to_re "sat")))))
; 100013Agentsvr\x5E\x5EMerlinIPBeta\s\x3E\x3C
(assert (str.in_re X (re.++ (str.to_re "100013Agentsvr^^Merlin\u{13}IPBeta") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "><\u{0a}"))))
; ^[\w]{3}(p|P|c|C|h|H|f|F|a|A|t|T|b|B|l|L|j|J|g|G)[\w][\d]{4}[\w]$
(assert (str.in_re X (re.++ ((_ re.loop 3 3) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.union (str.to_re "p") (str.to_re "P") (str.to_re "c") (str.to_re "C") (str.to_re "h") (str.to_re "H") (str.to_re "f") (str.to_re "F") (str.to_re "a") (str.to_re "A") (str.to_re "t") (str.to_re "T") (str.to_re "b") (str.to_re "B") (str.to_re "l") (str.to_re "L") (str.to_re "j") (str.to_re "J") (str.to_re "g") (str.to_re "G")) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) ((_ re.loop 4 4) (re.range "0" "9")) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) (str.to_re "\u{0a}"))))
; replace(MobileNo,' ',''),'^(\+44|0044|0)(7)[4-9][0-9]{8}$'
(assert (str.in_re X (re.++ (str.to_re "replaceMobileNo,' ','','") (re.union (str.to_re "+44") (str.to_re "0044") (str.to_re "0")) (str.to_re "7") (re.range "4" "9") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "'\u{0a}"))))
(check-sat)