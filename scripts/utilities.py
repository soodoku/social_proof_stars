"""A collection of common utility functions.

* save_mpl_fig
* split_dataframe
* split_dataframe2
* save_excelsheet
* pandas_to_tex
* pprint_dict
* save_json
* read_json
* read_jsons
"""
from typing import Any, Iterable, Optional
from typing import Dict

import os
import matplotlib.pyplot as plt
import pandas as pd
import json
from pprint import pprint


def save_mpl_fig(
    savepath: str, formats: Optional[Iterable[str]] = None, dpi: Optional[int] = None
) -> None:
    """Save matplotlib figures to ../output.

    Will handle saving in png and in pdf automatically using the same file stem.

    Parameters
    ----------
    savepath: str
        Name of file to save to. No extensions.
    formats: Array-like
        List containing formats to save in. (By default 'png' and 'pdf' are saved).
        Do a:
            plt.gcf().canvas.get_supported_filetypes()
        or:
            plt.gcf().canvas.get_supported_filetypes_grouped()
        To see the Matplotlib-supported file formats to save in.
        (Source: https://stackoverflow.com/a/15007393)
    dpi: int
        DPI for saving in png.

    Returns
    -------
    None
    """
    # Save pdf
    plt.savefig(
        f"../output/{savepath}.pdf", dpi=None, bbox_inches="tight", pad_inches=0
    )

    # save png
    plt.savefig(f"../output/{savepath}.png", dpi=dpi, bbox_inches="tight", pad_inches=0)

    # Save additional file formats, if specified
    if formats:
        for format in formats:
            plt.savefig(
                f"../output/{savepath}.{format}",
                dpi=None,
                bbox_inches="tight",
                pad_inches=0,
            )
    return None


def split_dataframe(dataframe: pd.DataFrame, chunk_size: int) -> list:
    """Split a dataframe into chunks of 'chunk_size'.

    From https://stackoverflow.com/a/28882020.

    Parameters
    ----------
    dataframe : pd.DataFrame
        Dataframe to be chunked.
    chunk_size : int
        Size of each chunk.

    Returns
    -------
    List
        List of chunked dataframes.
    """
    chunks = list()
    num_chunks = (len(dataframe) // chunk_size) + 1
    for i in range(num_chunks):
        chunks.append(dataframe[i * chunk_size : (i + 1) * chunk_size])
    return chunks


def split_dataframe2(dataframe: pd.DataFrame, n_chunks: int) -> list:
    """Split a dataframe into n chunks.

    Parameters
    ----------
    dataframe : pd.DataFrame
        Dataframe to be chunked.
    n_chunks : int
        How many chunks.

    Returns
    -------
    List
        List of chunked dataframes
    """
    # calculate the approximate chunk size
    chunk_size = len(dataframe) // n_chunks

    # split the dataframe into chunks
    chunks = [
        dataframe[i : i + chunk_size] for i in range(0, len(dataframe), chunk_size)
    ]

    if len(chunks) > n_chunks:  # More chunks than specified, b/c of remainder rows
        # Concatenate the last two chunks
        chunks = chunks[:-2] + [pd.concat([chunks[-2], chunks[-1]])]
    return chunks


def save_excelsheet(
    filepath: str, sheetname: str, table: pd.DataFrame, **kwargs: Any
) -> None:
    """
    Save Pandas DataFrame to Excel sheet, handling I/O and replacing existing sheets and files.

    Parameters
    ----------
    filepath : str
        Filepath of the Excel file.
    sheetname : str
        Name of the sheet to write the DataFrame to.
    table : pd.DataFrame
        DataFrame to be saved to Excel.
    **kwargs : Any
        Additional keyword arguments to be passed to pd.DataFrame.to_excel().

    Returns
    -------
    None
    """
    try:
        with pd.ExcelWriter(filepath, mode="a", if_sheet_exists="replace") as writer:
            table.to_excel(writer, sheet_name=sheetname, index=False, **kwargs)
    except:
        table.to_excel(filepath, sheet_name=sheetname, index=False, **kwargs)
    return None


def pandas_to_tex(
    df: pd.DataFrame, texfile: str, index: bool = False, **kwargs: Any
) -> None:
    """Save a Pandas dataframe to a LaTeX table fragment.

    Uses the built-in .to_latex() function. Only saves table fragments
    (equivalent to saving with "fragment" option in estout).

    Parameters
    ----------
    df: Pandas DataFrame
        Table to save to tex.
    texfile: str
        Name of .tex file to save to.
    index: bool
        Save index (Default = False).
    kwargs: any
        Additional options to pass to .to_latex().

    Returns
    -------
    None
    """
    if texfile.split(".")[-1] != ".tex":
        texfile += ".tex"

    tex_table = df.to_latex(index=index, header=False, **kwargs)
    tex_table_fragment = "\n".join(tex_table.split("\n")[3:-3])
    # Remove the last \\ in the tex fragment to prevent the annoying
    # "Misplaced \noalign" LaTeX error when I use \bottomrule
    # tex_table_fragment = tex_table_fragment[:-2]

    with open(texfile, "w") as tf:
        tf.write(tex_table_fragment)
    return None


def pprint_dict(data: Dict, indent: int = 2) -> None:
    """Pretty prints a dictionary.

    Parameters
    ----------
    data : dict
        The dictionary to be pretty printed.
    indent: int
        Number of indent spaces per line.

    Returns
    -------
    None
        This function doesn't return anything.

    Examples
    --------
    >>> sample_dict = {
    ...     "name": "John Doe",
    ...     "age": 30,
    ...     "city": "New York"
    ... }
    >>> pretty_print_dict(sample_dict)
    {
      "name": "John Doe",
      "age": 30,
      "city": "New York"
    }
    """
    # Convert the dictionary to a JSON string
    try:
        json_data = json.dumps(data, indent=indent)
    except TypeError:
        json_data = json.dumps(dict(data), indent=indent)

    # Pretty print the JSON data
    print(json_data)
    
    return None


def save_json(data, savepath):
    """
    Save a JSON object to a file.

    Parameters
    ----------
    data : dict
        The JSON object to be saved.
    file_path : str
        The path to the file where the JSON object will be saved.

    Returns
    -------
    None
    """    
    if savepath.split(".")[-1] != ".json":
        savepath += ".json"
    with open(savepath, "w") as file:
        json.dump(data, file)
    return None


def read_json(file_path: str) -> dict:
    """Read a JSON file and return its contents as a dictionary.

    Parameters
    ----------
    file_path: str
        The path to the JSON file.

    Returns
    -------
    Dict
        The contents of the JSON file as a dictionary.

    Raises:
        FileNotFoundError: If the file specified by file_path does not exist.
        json.JSONDecodeError: If the JSON file is malformed.

    Example:
        >>> data = read_json_file('data.json')
        >>> print(data['key_name'])
        value
    """
    if file_path.split(".")[-1] != "json":
        file_path += ".json"    
    with open(file_path) as file:
        data = json.load(file)
    return data


def read_jsons(directory: str, extension: str = ".json") -> list:
    """
    Read multiple JSON files from a directory and return their contents as a list.

    Parameters
    ----------
    directory : str
        The path to the directory containing the JSON files.

    Returns
    -------
    List[dict]
        A list containing the contents of the JSON files.

    Raises
    ------
    FileNotFoundError
        If the specified directory does not exist.
    NotADirectoryError
        If the specified path is not a directory.
    json.JSONDecodeError
        If any of the JSON files are malformed.

    Example
    -------
    >>> data_list = read_json_files_from_directory('json_files')
    >>> print(data_list[0]['key_name'])
    value
    """
    data_list = []
    for filename in os.listdir(directory):
        file_path = os.path.join(directory, filename)
        if os.path.isfile(file_path) and filename.endswith(extension):
                data_list.append(read_json(file_path))
    return data_list
