library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity gen is port( --entradas y salidas
	salida : out std_logic_vector(7 downto 0);
	led : out std_logic_vector(7 downto 0);
	AN : out std_logic_vector(7 downto 0);
	display : out std_logic_vector(7 downto 0);
	selector : in std_logic_vector(1 downto 0);
	clock : in std_logic;
	bip : out std_logic);
end gen;

architecture Behavioral of gen is --señales necesarias para el programa
	signal señal : std_logic_vector(7 downto 0):= "00000000";
	signal ANS : std_logic_vector(3 downto 0):= "1110";
	signal dis0 : std_logic_vector(7 downto 0):= x"FF";
	signal dis1 : std_logic_vector(7 downto 0):= x"FF";
	signal dis2 : std_logic_vector(7 downto 0):= x"FF";
	signal dis3 : std_logic_vector(7 downto 0):= x"FF";
	signal reloj : std_logic:= '0';
	signal cont : integer:= 1;
	signal clk : std_logic:= '0';
	signal reloj2 : std_logic:= '0';
	signal cont2 : integer:= 1;
	signal adress : integer:= 0;
	type sen_array is array (0 to 196) of std_logic_vector (7 downto 0);
	constant seno: sen_array :=(--Valores generados señal senoidal
	x"7E",x"82",x"86",x"8A",x"8E",x"92",x"96",x"9A",x"9E",x"A2",x"A6",x"A9",x"AD",x"B1",
	x"B5",x"B8",x"BC",x"BF",x"C3",x"C6",x"C9",x"CC",x"D0",x"D3",x"D6",x"D8",x"DB",x"DE",
	x"E0",x"E3",x"E5",x"E7",x"EA",x"EC",x"EE",x"EF",x"F1",x"F3",x"F4",x"F5",x"F7",x"F8",
	x"F9",x"FA",x"FA",x"FB",x"FB",x"FC",x"FC",x"FC",x"FC",x"FC",x"FB",x"FB",x"FA",x"FA",
	x"F9",x"F8",x"F7",x"F6",x"F4",x"F3",x"F1",x"F0",x"EE",x"EC",x"EA",x"E8",x"E6",x"E3",
	x"E1",x"DE",x"DC",x"D9",x"D6",x"D3",x"D0",x"CD",x"CA",x"C7",x"C3",x"C0",x"BC",x"B9",
	x"B5",x"B2",x"AE",x"AA",x"A6",x"A2",x"9F",x"9B",x"97",x"93",x"8F",x"8B",x"87",x"83",
	x"7F",x"7B",x"77",x"73",x"6F",x"6B",x"67",x"63",x"5F",x"5B",x"57",x"53",x"4F",x"4C",
	x"48",x"44",x"41",x"3D",x"3A",x"37",x"33",x"30",x"2D",x"2A",x"27",x"24",x"21",x"1F",
	x"1C",x"1A",x"17",x"15",x"13",x"11",x"0F",x"0D",x"0B",x"0A",x"08",x"07",x"05",x"04",
	x"03",x"03",x"02",x"01",x"01",x"01",x"01",x"01",x"01",x"01",x"01",x"01",x"01",x"02",
	x"03",x"04",x"05",x"06",x"07",x"09",x"0A",x"0C",x"0E",x"10",x"12",x"14",x"16",x"18",
	x"1B",x"1D",x"20",x"23",x"25",x"28",x"2B",x"2E",x"32",x"35",x"38",x"3C",x"3F",x"43",
	x"46",x"4A",x"4D",x"51",x"55",x"59",x"5D",x"61",x"65",x"69",x"6D",x"71",x"75",x"79",x"7D");
	type dien_array is array (0 to 196) of std_logic_vector (7 downto 0);
	constant diente: dien_array :=(--Valores generados para señal diente de sierra
	x"01",x"01",x"03",x"04",x"05",x"06",x"08",x"09",x"0A",x"0C",x"0D",x"0E",x"0F",x"11",
	x"12",x"13",x"15",x"16",x"17",x"18",x"1A",x"1B",x"1C",x"1E",x"1F",x"20",x"21",x"23",
	x"24",x"25",x"27",x"28",x"29",x"2A",x"2C",x"2D",x"2E",x"2F",x"31",x"32",x"33",x"35",
	x"36",x"37",x"38",x"3A",x"3B",x"3C",x"3E",x"3F",x"40",x"41",x"43",x"44",x"45",x"47",
	x"48",x"49",x"4A",x"4C",x"4D",x"4E",x"50",x"51",x"52",x"53",x"55",x"56",x"57",x"59",
	x"5A",x"5B",x"5C",x"5E",x"5F",x"60",x"62",x"63",x"64",x"65",x"67",x"68",x"69",x"6B",
	x"6C",x"6D",x"6E",x"70",x"71",x"72",x"74",x"75",x"76",x"77",x"79",x"7A",x"7B",x"7C",
	x"7E",x"7F",x"80",x"82",x"83",x"84",x"85",x"87",x"88",x"89",x"8B",x"8C",x"8D",x"8E",
	x"90",x"91",x"92",x"94",x"95",x"96",x"97",x"99",x"9A",x"9B",x"9D",x"9E",x"9F",x"A0",
	x"A2",x"A3",x"A4",x"A6",x"A7",x"A8",x"A9",x"AB",x"AC",x"AD",x"AF",x"B0",x"B1",x"B2",
	x"B4",x"B5",x"B6",x"B8",x"B9",x"BA",x"BB",x"BD",x"BE",x"BF",x"C1",x"C2",x"C3",x"C4",
	x"C6",x"C7",x"C8",x"C9",x"CB",x"CC",x"CD",x"CF",x"D0",x"D1",x"D2",x"D4",x"D5",x"D6",
	x"D8",x"D9",x"DA",x"DB",x"DD",x"DE",x"DF",x"E1",x"E2",x"E3",x"E4",x"E6",x"E7",x"E8",
	x"EA",x"EB",x"EC",x"ED",x"EF",x"F0",x"F1",x"F3",x"F4",x"F5",x"F6",x"F8",x"F9",x"FA",x"FC");
	type cuad_array is array (0 to 196) of std_logic_vector (7 downto 0);
	constant cuadrada: cuad_array :=(--Valores generados para señal cuadrada
	x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
	x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
	x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
	x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
	x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
	x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
	x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
	x"00",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",
	x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",
	x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",
	x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",
	x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",
	x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",
	x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF");
	type trian_array is array (0 to 196) of std_logic_vector (7 downto 0);
	constant triangular: trian_array :=(--Valores generados para señal triangular
	x"01",x"03",x"05",x"08",x"0A",x"0D",x"0F",x"12",x"15",x"17",x"1A",x"1C",x"1F",x"21",
	x"24",x"27",x"29",x"2C",x"2E",x"31",x"33",x"36",x"38",x"3B",x"3E",x"40",x"43",x"45",
	x"48",x"4A",x"4D",x"50",x"52",x"55",x"57",x"5A",x"5C",x"5F",x"62",x"64",x"67",x"69",
	x"6C",x"6E",x"71",x"74",x"76",x"79",x"7B",x"7E",x"80",x"83",x"85",x"88",x"8B",x"8D",
	x"90",x"92",x"95",x"97",x"9A",x"9D",x"9F",x"A2",x"A4",x"A7",x"A9",x"AC",x"AF",x"B1",
	x"B4",x"B6",x"B9",x"BB",x"BE",x"C1",x"C3",x"C6",x"C8",x"CB",x"CD",x"D0",x"D2",x"D5",
	x"D8",x"DA",x"DD",x"DF",x"E2",x"E4",x"E7",x"EA",x"EC",x"EF",x"F1",x"F4",x"F6",x"F9",
	x"FC",x"FA",x"F7",x"F5",x"F2",x"F0",x"ED",x"EA",x"E8",x"E5",x"E3",x"E0",x"DE",x"DB",
	x"D9",x"D6",x"D3",x"D1",x"CE",x"CC",x"C9",x"C7",x"C4",x"C1",x"BF",x"BC",x"BA",x"B7",
	x"B5",x"B2",x"AF",x"AD",x"AA",x"A8",x"A5",x"A3",x"A0",x"9D",x"9B",x"98",x"96",x"93",
	x"91",x"8E",x"8C",x"89",x"86",x"84",x"81",x"7F",x"7C",x"7A",x"77",x"74",x"72",x"6F",
	x"6D",x"6A",x"68",x"65",x"62",x"60",x"5D",x"5B",x"58",x"56",x"53",x"50",x"4E",x"4B",
	x"49",x"46",x"44",x"41",x"3F",x"3C",x"39",x"37",x"34",x"32",x"2F",x"2D",x"2A",x"27",
	x"25",x"22",x"20",x"1D",x"1B",x"18",x"15",x"13",x"10",x"0E",x"0B",x"09",x"06",x"03",x"01");
begin
-----------------Definicón de señales con entradas y salidas---------------------------------------------------
	clk <= clock; 								--Señal para dos divisores de frcuencia futura
	led <= señal;								--Leds testigos que muestren la señal de salida
	salida <= señal;							--Salida que ira a la DAC (8 bits)
	process(señal) begin
		if señal > x"F9" then
			bip <= '1';
		else bip <= '0';
		end if;
	end process;
	
-----------------Divisor de frecuencia número 1----------------------------------------------------------------		
	process(clk) begin						--se crea un proceso que ocupa la variable clk (cristal oscilador)
		if clk'event and clk = '1' then	--cada que la variable clk cambie (de o a 1 o veceversa)
			if cont = 350000 then 			--cada que el contador sea igual a 350000
				reloj <= not reloj;			--la señal reloj se niega (como se inicializó en 0 ahora cambia a 1)
				cont <= 1;						--contador lo igualamos otra vez a 1 
			else									
				cont <= cont + 1;				--en otro caso solo el contador se le suma un termino
			end if;
		end if;
	end process;

-----------------Divisor de frecuencia displays ----------------------------------------------------------------		
	process(clk) begin						--se crea un proceso que ocupa la variable clk (cristal oscilador)
		if clk'event and clk = '1' then	--cada que la variable clk cambie (de o a 1 o veceversa)
			if cont2 = 25000 then		 	--cada que el contador sea igual a 25000
				reloj2 <= not reloj2;		--la señal reloj2 se niega (como se inicializó en 0 ahora cambia a 1)
				cont2 <= 1;						--contador lo igualamos otra vez a 1 
			else									
				cont2 <= cont2 + 1;			--en otro caso solo el contador se le suma un termino
			end if;
		end if;
	end process;
	
------------------------------ADRESS----------------------------------------------------------------------------
	process(reloj) begin --proceso para cambio de valor de la señal de 197 valores
		if (reloj'event and reloj ='1') then
			if (adress = 196 or adress < 196) then
				adress <= adress +1;
			else adress <= 0;
			end if;
		else adress <= 0;
		end if;
	end process;
-----------------------DISPLAYS----------------------------------------------------------------------------------
	process(reloj2, ANS) begin
		if (reloj2'event and reloj2 = '1') then
			ANS(0) <= ANS(3);--Corrimiento de
			ANS(1) <= ANS(0);--Anodos de display
			ANS(2) <= ANS(1);
			ANS(3) <= ANS(2);		
		else
			ANS <= ANS;
		end if;
		case ANS is --Definición de letras en display
			when "1110" => dis2 <= "00010001";--A
								dis0 <= "00000011";--O
								dis1 <= "11010101";--n
								dis3 <= "10000101";--d
			when "1101" => dis2 <= "10011111";--i
								dis0 <= "11010101";--n
								dis1 <= "01100001";--E
								dis3 <= "00010001";--A
			when "1011" => dis2 <= "11110101";--r
								dis0 <= "01100001";--E
								dis1 <= "10011111";--i
								dis3 <= "10000011";--U
			when "0111" => dis2 <= "11100001";--t
								dis0 <= "01001001";--S
								dis1 <= "10000101";--d
								dis3 <= "01100011";--C
			when others => dis2 <= x"00";--CEROS
								dis0 <= x"00";
								dis1 <= x"00";
								dis3 <= x"00";
		end case;
	end process;
-----------------------Seleccionador de señal-----------------------------------------------------------------
	process(selector, ANS, dis1, dis0, reloj2) begin
		if (reloj2'event and reloj2 = '1') then
			if selector = "00" then
				display <= dis1;
				AN <= "1111" & ANS;
				señal <= diente(adress);
			elsif selector = "01" then
				display <= dis0;
				AN <= ANS & "1111";
				señal <= seno(adress);
			elsif selector = "10" then
				display <= dis2;
				AN <=	"1111" & ANS;
				señal <= triangular(adress);
			elsif selector = "11" then
				display <= dis3;
				AN <= ANS & "1111";
				señal <= cuadrada(adress);
			end if;
		else
		end if;
	end process;
end Behavioral;
